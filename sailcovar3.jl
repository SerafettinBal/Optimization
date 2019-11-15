using JuMP, Clp , Printf

demand = [40 60 75 25]                  

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, x_regular[1:4] <= 40) 
@variable(m, y_overtime[1:4] >= 0) 
@variable(m, held[1:5] >= 0)            
@variable(m, min_c[1:4] >= 0)            
@variable(m, pos_c[1:4] >= 0)  
@variable(m, min_held[1:5] >= 0)            
@variable(m, pos_held[1:5] >= 0)          

@constraint(m, pos_held[4] >= 10)        
@constraint(m, min_held[4] <= 0)         
@constraint(m, pos_held[1]-min_held[1] ==  (10)+x_regular[1]+y_overtime[1]-d[1])
@constraint(m, x_regular[1]+y_overtime[1]-(50) == pos_c[1]-min_c[1])
@constraint(m, flow[i in 1:3], (pos_held[i+1] - min_held[i+1]) == (pos_held[i] - min_held[i]) + x_regular[i+1]+y_overtime[i+1]-demand[i+1])
@constraint(m, stream[i in 1:3], x_regular[i+1]+y_overtime[i+1]-(x_regular[i]+y_overtime[i]) == pos_c[i+1]-min_c[i+1])

@objective(m, Min, 400*sum(x_regular) + 450*sum(y_overtime) + 20*sum(pos_held) + 100*sum(min_held) + 400*sum(pos_c) + 500*sum(min_c)) 

status = optimize!(m)

@printf("Boats with regular labour: %d %d %d %d \n", value(x_regular[1]), value(x_regular[2]), value(x_regular[3]), value(x_regular[4]))
@printf("Boats with overtime labour: %d %d %d %d \n", value(y_overtime[1]), value(y_overtime[2]), value(y_overtime[3]), value(y_overtime[4]))
@printf("Inventories for mouth: %d %d %d %d %d\n ", value(held[1]), value(held[2]), value(held[3]), value(held[4]), value(held[5]))
@printf("Positive held values: %d %d %d %d %d\n", value(pos_held[1]), value(pos_held[2]), value(pos_held[3]), value(pos_held[4]), value(pos_held[5]))
@printf("Negative held values: %d %d %d %d %d\n", value(min_held[1]), value(min_held[2]), value(min_held[3]), value(min_held[4]), value(min_held[5]))
#@printf("Positive c values: %d %d %d %d\n", value(pos_c[1]), value(pos_c[2]), value(pos_c[3]), value(pos_c[4]))      
#@printf("Negative c values: %d %d %d %d\n", value(min_c[1]), value(min_c[2]), value(min_c[3]), value(min_c[4]))        
@printf("Objective cost: %f\n", objective_value(m))