include("src/VanDerPol.jl")
using DataDrivenDiffEq
using ModelingToolkit
using LinearAlgebra
using Plots

@time begin 
global dt = 0.01
global Nsim = 200
global Ntraj = 10  # 1000

global X_hist = zeros(2, Nsim * Ntraj)
global Y_hist = zeros(2, Nsim * Ntraj)
global U_hist = zeros(1, Nsim * Ntraj)
global t_hist = zeros(1, Nsim * Ntraj)

for k = 1:(Ntraj*Nsim)
    if k % 200 == 1
        global X_k = 2 .* rand(2) .- 2
    end
    u_k = 2 .* rand(1) .- 1
    u_k = u_k[1]
    X_k1 = VanDerPol.VDP_step(X_k, u_k, dt)
    X_hist[:,k] = X_k
    Y_hist[:,k] = X_k1 
    U_hist[k] = u_k 
    t_hist[k] = k*dt
    X_k = X_k1
end

println("Number of datapoints gathered: ", size(X_hist), size(Y_hist), size(U_hist))
println("Time to gather data:")
end

# ------- Fit the Model -------- #

# Define a direct, discrete data driven problem
prob = DirectDataDrivenProblem(X_hist, vec(t_hist), Y_hist, U_hist)
#plot(prob)

# Define a Koopman basis
@parameters t
@variables x[1:2], y[1:2], u[1:1]
implicits = polynomial_basis(x,2)
push!(implicits, u...)
#basis = Basis(implicits, x, implicits = y, controls = u, iv=t)
basis = Koopman(implicits, x, observed = y, controls = u, iv=t)
println(basis)

# Solve the data driven problem
# res = solve(prob, basis, DMDSVD())



# ------- Do MPC -------- #