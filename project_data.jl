# Data file for project.jl

# Sets
N = collect(1:11) # Nodes k
E = [[N[1],N[2]], [N[1],N[11]], [N[2],N[3]], [N[2],N[11]], [N[3],N[4]], [N[3],N[9]], [N[4],N[5]], [N[5],N[6]], [N[5],N[8]], [N[6],N[7]], [N[7],N[8]], [N[7],N[9]], [N[8],N[9]], [N[9],N[10]], [N[10],N[11]]] # Edges (k,l)
G = collect(1:9) # Generators G_i
Gk = [Int[], [G[1], G[2], G[3]], G[4], G[5], G[6], Int[], G[7], Int[], [G[8],G[9]],Int[], Int[] ] # Set of generators g_i at node k

C = collect(1:7) # Consumers C_j
Ck = [C[1], Int[], Int[], C[2], Int[], C[3], Int[], C[4], C[5], C[6], C[7]] # Set of consumers c_j at node k

# Parameters
KGi = [175, 100, 150, 150, 300, 350, 400, 300, 200] # Energy production cost [SEK/pu]
MGi = [0.02, 0.15, 0.08, 0.07, 0.04, 0.17, 0.17, 0.26, 0.05] # Maximum capacity [pu}]
Dj = [0.1, 0.19, 0.11, 0.09, 0.21, 0.05, 0.04] # Demand active power[pu]
bkl = [-20.1, -22.3, -16.8, -17.2, -11.7, -19.4, -10.8, -12.3, -9.2, -13.9, -8.7, -11.3, -7.7, -13.5, -26.7]
gkl=[4.12, 5.67, 2.41, 2.78, 1.98, 3.23, 1.59, 1.71, 1.26, 1.11, 1.32, 2.01, 4.41, 2.14, 5.06]

# Variables
k_nodes = length(N) # Number of k nodes
n_generators = length(G) # Number of k nodes
n_edges = length(E) # Number of possible edges

# n_vars_second_dimension = 2 # Number of variables in second dimension
# lb = 0 # Lower bounds for the varaibles; same for all of them
# ub = [[3, 2] [4, 1]] # Upper bounds for the variables
# sum_bound = 7.75 # Constraint on sum of variables
