using JuMP
import Ipopt

# Import data from the data file
include("project_data.jl")

display(E)
# Create the model object
the_model = Model(Ipopt.Optimizer)

# Create the variables and set their common lower bound
@variables(
    the_model,
    begin
        x[1:n_generators]
        y[1:n_generators]

        # Active & reactive power flow variables
        pkl[1:n_edges]
        plk[1:n_edges]
        qkl[1:n_edges]
        qlk[1:n_edges]

        #Voltage & angle variables
        v[1:k_nodes]
        theta[1:k_nodes]
    end
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
    v_constr[k = 1:k_nodes],
    0.98 <= v[k] <= 1.02
)

@constraint(
    the_model,
    theta_constr[k = 1:k_nodes],
    -pi <= theta[k] <= pi
)
# System Balances
@constraint(
    the_model,
    active_power_balance[k = 1:k_nodes],
    sum(x[g] for g in Gk[k]) - sum(Dj[j] for j in Ck[k]) == sum(pkl[e] for e in 1:n_edges if E[e][1] == k) + sum(plk[e] for e in 1:n_edges if E[e][2] == k)
)
@constraint(
    the_model,
    reactive_power_balance[k = 1:k_nodes],
    sum(y[g] for g in Gk[k]) == 
        sum(qkl[e] for e in 1:n_edges if E[e][1] == k) + 
        sum(qkl[e] for e in 1:n_edges if E[e][2] == k)
)

# Power Flow Definitions
# p_kl definition (Equation p_def)
@constraint(
    the_model,
    p_def[e = 1:n_edges],
    pkl[e] == v[E[e][1]]^2 * gkl[e] - 
            v[E[e][1]] * v[E[e][2]] * gkl[e] * cos(theta[E[e][1]] - theta[E[e][2]]) - 
            v[E[e][1]] * v[E[e][2]] * bkl[e] * sin(theta[E[e][1]] - theta[E[e][2]]))

# p_lk definition (Equation p_def)
@constraint(
    the_model,
    pl_def[e = 1:n_edges],
    plk[e] == v[E[e][2]]^2 * gkl[e] - 
             v[E[e][1]] * v[E[e][2]] * gkl[e] * cos(theta[E[e][2]] - theta[E[e][1]]) - 
             v[E[e][1]] * v[E[e][2]] * bkl[e] * sin(theta[E[e][2]] - theta[E[e][1]]))

# q_kl definition (Equation q_def)
@constraint(
    the_model,
    q_def[e = 1:n_edges],
    qkl[e] == -v[E[e][1]]^2 * bkl[e] + 
             v[E[e][1]] * v[E[e][2]] * bkl[e] * cos(theta[E[e][1]] - theta[E[e][2]]) - 
             v[E[e][1]] * v[E[e][2]] * gkl[e] * sin(theta[E[e][1]] - theta[E[e][2]])
)

# q_lk definition (Equation q_def)
@constraint(
    the_model,
    ql_def[e = 1:n_edges],
    qlk[e] == -v[E[e][2]]^2 * bkl[e] + 
              v[E[e][1]] * v[E[e][2]] * bkl[e] * cos(theta[E[e][2]] - theta[E[e][1]]) - 
              v[E[e][1]] * v[E[e][2]] * gkl[e] * sin(theta[E[e][2]] - theta[E[e][1]])
)

# Print the optimization problem in the terminal
println("The optimization problem is:")
println(the_model)

# Solve the optimization problem
println("Solving the optimization problem...")
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







