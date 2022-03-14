include("src/VanDerPol.jl")
using DataDrivenDiffEq
using ModelingToolkit
using LinearAlgebra

@time begin 
global dt = 0.01
global Nsim = 200
global Ntraj = 1000

global X_hist = zeros(Nsim * Ntraj, 2)
global Y_hist = zeros(Nsim * Ntraj, 2)
global U_hist = zeros(Nsim * Ntraj, 1)

for k = 1:(Ntraj*Nsim)
    if k % 200 == 1
        global X_k = 2 .* rand(2) .- 2
    end
    u_k = 2 .* rand(1) .- 1
    u_k = u_k[1]
    X_k1 = VanDerPol.VDP_step(X_k, u_k, dt)
    X_hist[k,:] = X_k
    Y_hist[k,:] = X_k1 
    U_hist[k] = u_k 
    X_k = X_k1
end

println("Number of datapoints gathered: ", size(X_hist))
println("Time to gather data:")
end

# ------- Fit the Model -------- #
prob = DiscreteDataDrivenProblem(X_hist, Y=Y_hist, U=U_hist)


# ------- Do MPC -------- #