using JuMP, Clp , Printf

demand = [40 60 75 25]                  

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, x_regular[1:4] <= 40) 
@variable(m, y_overtime[1:4] >= 0) 
@variable(m, held[1:5] >= 0)            
@variable(m, min_c[1:4] >= 0)            
@variable(m, pos_c[1:4] >= 0)  

@constraint(m, held[1] == 10)
@constraint(m, flow1[i in 1:4], x_regular[i+1]+y_overtime[i+1]-x_regular[i]-y_overtime[i]==pos_c[i+1]-min_c[i+1]) 
@constraint(m, flow2[i in 1:4], held[i]+x_regular[i]+y_overtime[i]-demand[i]==held[i+1])
@objective(m, Min, 400*sum(x_regular) + 450*sum(y_overtime) + 20*sum(held) + 400*sum(pos_c) + 500*sum(min_c))    

status = optimize!(m)

@printf("Boats with regular labour: %d %d %d %d \n", value(x_regular[1]), value(x_regular[2]), value(x_regular[3]), value(x_regular[4]))
@printf("Boats with overtime labour: %d %d %d %d \n", value(y_overtime[1]), value(y_overtime[2]), value(y_overtime[3]), value(y_overtime[4]))
@printf("Monthly inventories %d %d %d %d %d\n ", value(held[1]), value(held[2]), value(held[3]), value(held[4]), value(held[5]))

@printf("Total cost: %f\n", objective_value(m))