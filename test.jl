include("src/VanDerPol.jl")
using Plots

x = [0.5, 0.5]
#x = [-0.1, -0.5]

global dt = 0.01
Tmax = 3
Nsim = Integer(Tmax/dt)


# Allocate arrays for data storage
global X_hist = zeros(Nsim+1, 2)
X_hist[1,:] = x
global U_hist = zeros(Nsim, 1)

# Define control signal
u_dt(j) = (-1) ^ (round(j/30))

for i = 1:Nsim
    X_hist[i+1,:] = VanDerPol.VDP_step(X_hist[i,:], u_dt(i), dt)
    U_hist[i] = u_dt(i)
end


plot(1:Nsim+1, X_hist[:,1], label="x1")
plot!(1:Nsim+1, X_hist[:,2], label="x2")
plot!(1:Nsim, U_hist, label="u")