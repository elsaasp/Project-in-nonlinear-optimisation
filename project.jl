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
    x[1:n_generators],
    y[1:n_generators],
    pkl[1:n_edges],
    gkl[1:n_edges],
    v[1:n_generators],
    theta[1:n_generators],
)

@objective(
    the_model,
    Min,
    sum(
        (x[i] * KGi[i])
        for i in 1:n_generators
    ),
)

# Variable bounds
@constraint(
    the_model,
    x_constr[i = 1:n_generators],
    0 <= x[i] <= MGi[i] #Production constraint
)

@constraint(
    the_model,
    y_constr[i = 1:n_generators],
    -0.03 * MGi[i] <= y[i] <= 0.03 * MGi[i] #Reactive power constraint
)

@constraint(
    the_model,
    v_constr[k = 1:n_nodes],
    0.98 <= v[k] <= 1.02
)

@constraint(
    the_model,
    theta_constr[k = 1:n_nodes],
    -pi <= theta[k] <= pi
)


# Power Flow Definitions
pkl = v[k][1]^2

# Production constraints

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


# p_kl definition (Equation p_def)
@constraint(
    the_model,
    p_def[e = 1:n_edges],
    pkl[e] == v[E[e][1]]^2 * gkl[e] - 
            v[E[e][1]] * v[E[e][2]] * gkl[e] * cos(theta[E[e][1]] - theta[E[e][2]]) - 
            v[E[e][1]] * v[E[e][2]] * bkl[e] * sin(theta[E[e][1]] - theta[E[e][2]]))

# q_kl definition (Equation q_def)
@constraint(
    the_model,
    q_def[e = 1:n_edges],
    qkl[e] == -v[E[e][1]]^2 * bkl[e] + 
             v[E[e][1]] * v[E[e][2]] * bkl[e] * cos(theta[E[e][1]] - theta[E[e][2]]) - 
             v[E[e][1]] * v[E[e][2]] * gkl[e] * sin(theta[E[e][1]] - theta[E[e][2]])
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







