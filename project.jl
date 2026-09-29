using JuMP
import Ipopt

# Import data from the data file
include("project_data.jl")

display(E)
# Create the model object
the_model = Model(Ipopt.Optimizer)

# Create the variables and set their common lower bound
@variable(
    the_model,
    x[1:n_generators] >= lb,
)


@objective(
    the_model,
    Min,
    sum(
        (x[i] * KGi[i])
        for i in 1:n_generators
    ),
)

# Power Flow Definitions
pkl = v[k][1]^2

# Production constraints
@constraint(
    the_model,
    ub_constr[i = 1:n_generators],
    x[i] <= MGi[i],
)

@constraint(
    the_model,
    reactive_constr,
    -0.03*MGi[i] <= y[i] <= 0.03*MGi[i]
    for k in N 
)

# Transmission constraints
@constraint(
    the_model,
    theta_constr,
    -pi <= theta[k] <= pi
    for k in N 
)

@constraint(
    the_model,
    v_constr,
    0.98 <= v[k] <= 1.02
    for k in N
)





# Print the optimization problem in the terminal
println(the_model)

# Solve the optimization problem
optimize!(the_model)

# Print selected results for further analysis
# NOTE: This is the type of output you need to analyise in your project.
#       You can use the output to check if the solver has found a solution, what the solution is, and what the dual variables are.
println("") # Printing white line after solver output, before printing
println("Termination status: ", termination_status(the_model))
println("Optimal objective function value: ", objective_value(the_model))
println("Optimal point: ", value.(x))
println("Dual variables/Lagrange multipliers corresponding to some constraints:")
println(dual.(ub_constr))
println(dual.(LowerBoundRef.(x)))







