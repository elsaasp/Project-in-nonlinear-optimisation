# Small data file to show how one can import julia files into other julia files.
# For example, this gives a convenient way to create files containing all the data for a problem.

# Sets
N = [1:11] # Nodes k
E = [[N[1],N[2]] [N[1],N[11]] [N[2],N[3]] [N[2],N[11]] [N[3],N[4]] [N[3],N[9]] [N[4],N[5]] [N[5],N[6]] [N[5],N[8]]] # Edges (k,l)
Gk = [ empty, [G[1], G[2], G[3]], G[4], G[5], G[6], empty, G[7], empty, [G[8,G[9]]],empty, empty ] # Set of generators g_i at node k
Ck = [C[1], empty, empty, C[2], empty, C[3], empty, C[4], C[5], C[6], C[7]] # Set of consumers c_j at node k

# Parameters
G = [1:9] # Generators G_i
C = [1:7] # Consumers C_j
# Variables
n_vars_first_dimension = 2 # Number of variables in first dimension
n_vars_second_dimension = 2 # Number of variables in second dimension
lb = 0 # Lower bounds for the varaibles; same for all of them
ub = [[3, 2] [4, 1]] # Upper bounds for the variables
sum_bound = 7.75 # Constraint on sum of variables
