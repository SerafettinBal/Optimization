using JuMP, Clp, Printf

demand = [ 60 75 25 36]        # monthly demand for boats        
#actualdemand = [ 55 70 25 31]      #suppose 
m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0 <= x_regular[1:4] <= 40)       
@variable(m, y_overtime[1:4] >= 0)            
@variable(m, held[1:5] >= 0)            
@constraint(m, held[1] == 15)
@constraint(m, held[5] >=10)
@constraint(m, flow[i in 1:4], held[i]+x_regular[i]+y_overtime[i]==demand[i]+held[i+1])   
@objective(m, Min, 400*sum(x_regular) + 450*sum(y_overtime) + 20*sum(held))     

optimize!(m)

@printf("Boats to build regular labor: %d %d %d %d\n", value(x_regular[1]), value(x_regular[2]), value(x_regular[3]), value(x_regular[4]))
@printf("Boats to build extra labor: %d %d %d %d\n", value(y_overtime[1]), value(y_overtime[2]), value(y_overtime[3]), value(y_overtime[4]))
@printf("Inventories: %d %d %d %d %d\n ", value(held[1]), value(held[2]), value(held[3]), value(held[4]), value(held[5]))

@printf("Objective cost: %f\n", objective_value(m))