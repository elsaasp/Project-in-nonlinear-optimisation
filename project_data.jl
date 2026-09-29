# Small data file to show how one can import julia files into other julia files.
# For example, this gives a convenient way to create files containing all the data for a problem.

# Sets
N = [1:11] # Nodes k
E = [[N[1],N[2]] [N[1],N[11]] [N[2],N[3]] [N[2],N[11]] [N[3],N[4]] [N[3],N[9]] [N[4],N[5]] [N[5],N[6]] [N[5],N[8]]] # Edges (k,l)

G = [1:9] # Generators G_i
Gk = [0, [G[1], G[2], G[3]], G[4], G[5], G[6], 0, G[7], 0, [G[8,G[9]]],0, 0 ] # Set of generators g_i at node k

C = [1:7] # Consumers C_j
Ck = [C[1], 0, 0, C[2], 0, C[3], 0, C[4], C[5], C[6], C[7]] # Set of consumers c_j at node k

# Parameters
<<<<<<< HEAD
KGi = [175 100 150 150 300 350 400 300 200] # Energy production cost [SEK/pu]
MGi = [0.02, 0.15, 0.08, 0.07, 0.04, 0.17, 0.26, 0.05]
Dj = [0.1 0.19 0.11 0.09 0.21 0.05 0.04] # Demand active power[pu]
bkl = 
=======
KGi = 

Dj =
>>>>>>> a00eaf8054f486667518a02df3b8df95044a7fdb


# Variables
n_vars_first_dimension = 2 # Number of variables in first dimension
n_vars_second_dimension = 2 # Number of variables in second dimension
lb = 0 # Lower bounds for the varaibles; same for all of them
ub = [[3, 2] [4, 1]] # Upper bounds for the variables
sum_bound = 7.75 # Constraint on sum of variables
