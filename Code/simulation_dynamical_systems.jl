using CairoMakie
using DataFrames
using DifferentialEquations
using Distributions
using DynamicalSystems
using Profile
using Random
using Statistics


"""
    threePlusOneDimensions!(du, u, p, t)
    
This function implements the 3 + 1 Dimensions Model. Please check the paper for details (can be found here:
    https://www.frontiersin.org/articles/10.3389/fpsyg.2023.1099257/full). 

    # Arguments
    - 'du' = : The derivatives of the functions x, y, z, f
    - 'u' = : The functions x, y, z, f
    - 'p' = : Parameters Smax, τx, τy, τz, τf, α, β, P, S, Rₛ, L, λᵦ, λₛ
    - 't' = : Used by coupledODEs function. Does something under the hood.
"""
function threePlusOneDimensions!(du, u, p, t)

    gauss = 0.2
    Smax, τx, τy, τz, τf, α, β, P, S, Rₛ, L, λᵦ, λₛ = p

    du[1] = (Smax /(1 + exp((Rₛ - u[2]) / λₛ)) - u[1]) / τx
    du[2] = (P / (1 + exp((Rₛ - u[2]) / λₛ)) + u[4] * L - u[1] * u[2] - u[3]) / τy
    du[3] = (S * (α * u[1] + β * u[2]) - u[3]) / τz
    du[4] = (u[2] - λᵦ * u[4]) * gauss / τf
    return nothing
end 

# Settings
totalTime = 20
samplingTime = 1

# Set the starting conditions and parameters of the model
p₀ = [10, 14, 14, 2, 1, 0.5, 0.5, 10, 10, 1, 1.01, 0.05, 0.1]
u₀ = [0.0, 0.1, 0.0, 0.0]

# Saves the threePlusOneDimensions as a Dynamical Systems object using the rule specified above
threePlusOneDimensions = CoupledODEs(threePlusOneDimensionsRule!, u₀, p₀)

trajectory(threePlusOneDimensions)

# Create figure
fig = Figure()
ax = Axis(fig[1, 1]; xlabel = "time", ylabel = "variable")
for var in columns(X[ ])
    lines!(ax, t, var)
end
fig[1, 2] = Legend(fig, ax, "Variables", framevisible = false)

# Show figure
fig
