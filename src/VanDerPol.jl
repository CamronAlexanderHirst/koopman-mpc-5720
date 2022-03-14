module VanDerPol

x_dot(x,u) = [2*x[2], (-0.8)*x[1] + 2*x[2] - 10*x[2]*(x[1]^2) + u]

function VDP_step(x,u,dt)
    deltaT = dt
    k1 = x_dot(x,u)
    k2 = x_dot(x + k1*deltaT/2,u)
    k3 = x_dot(x + k2*deltaT/2,u)
    k4 = x_dot(x + k3*deltaT,u)
    x_next =  x + (deltaT/6) * (k1 + 2*k2 + 2*k3 + k4)
    return x_next
end

end  # module