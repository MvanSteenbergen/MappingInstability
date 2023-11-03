using DynamicalSystems

function lorenz_rule(u, p, t)
    σ, ρ, β = p
    x, y, z = u
    dx = σ*(y - x)
    dy = x*(ρ - z) - y
    dz = x*y - β*z
    return SVector(dx, dy, dz)
end

p = [10.0, 28.0, 8/3]
u₀ = [0.0, 10.0, 0.0]
lorenz = ContinuousDynamicalSystem(lorenz_rule, u₀, p)

T = 100.0
Δt = 0.01
A = trajectory(lorenz, T; Δt)