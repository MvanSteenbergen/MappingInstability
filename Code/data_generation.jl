using DataFrames
using DifferentialEquations
using Distributions
using DynamicalSystems
using Random
using JLD2
using CSV

## DATA GENERATION

"""
    threePlusOneDimensions!(du, u, p, t)
    
This function implements the 3 + 1 Dimensions Model. Please check the paper for details (can be found here:
    https://www.frontiersin.org/articles/10.3389/fpsyg.2023.1099257/full). 

    # Arguments
    - 'du' = : The derivatives of the functions x, y, z, f
    - 'u' = : The functions x, y, z, f
    - 'p' = : Parameters Smax, Rₛ, λₛ, τx, P, Rᵦ, λᵦ, L, τᵧ, S, α, β, τz, ζ 
    - 't' = : Represents time. Not directly called.
"""
function threePlusOneDimensions!(du, u, p, t)
    Smax, Rₛ, λₛ, τx, P, Rᵦ, λᵦ, L, τᵧ, S, α, β, τz, ζ, λf, τf  = p

    du[1] = (Smax /(1 + exp((Rₛ - u[2]) / λₛ)) - u[1]) / τx
    du[2] = (P / (1 + exp((Rᵦ - u[2]) / λᵦ)) + u[4] * L - u[1] * u[2] - u[3]) / τᵧ
    du[3] = (S * (α * u[1] + β * u[2]) * p[14] - u[3]) / τz
    du[4] = (u[2] - λf * u[4]) / τf
    return nothing
end 

"""
    affect!(integrator)

This function adds Gaussian noise between 0 and 1 at each 0.01th timepoint and saves it as the ζ-term (which is equivalent to integrator.p[14]).
"""
function affect!(integrator)
    integrator.p[14] = clamp(rand(Normal(0, 0.5)), -1.0, 1.0)
    return nothing
end

# Implementation of the periodic callback that uses the affect function above to update the value of ζ in threePlusOneDimensions every 0.01 t.
cb = PeriodicCallback(affect!, 0.01)


# Calculation of the trajectory based on the rules above and return it as a statespaceset
function calculateTrajectory(p₀)
    u₀ = [0.0, 0.01, 0.0, 0.0]
    startat = 0.0
    stopat = 12000.0
    saveat = 0.2
    prob = ODEProblem(threePlusOneDimensions!, u₀, (startat, stopat), p₀)
    data = solve(prob, Tsit5(), callback = cb, reltol = 1e-9, abstol = 1e-9, saveat = saveat, maxiters = 1e7)
    data = DataFrame(data)
    unique!(data)
    
    startat = 10000.0
    filter!(:timestamp => ts -> ts in startat:saveat:stopat, data)
    return data
end

# Set the starting conditions and parameters of the model, and calculate the trajectory.
# I strongly recommend only running one at a time, to avoid running out of memory
healthy = calculateTrajectory([10, 1, 0.1, 14, 10, 1.04, 0.05, 0.2, 14, 4, 0.5, 0.5, 1, 0.2, 1, 720])
schizophrenia = calculateTrajectory([10, 1, 0.1, 14, 10, 0.904, 0.05, 0.2, 14, 4, 0.5, 0.5, 1, 0.2, 1, 720])
bipolar = calculateTrajectory([10, 1, 0.1, 14, 10, 1.04, 0.05, 1.01, 14, 10, 0.5, 0.5, 1, 0.2, 1, 720])
bereavement = calculateTrajectory([10, 1, 0.1, 14, 10, 1, 0.05, 0.6, 14, 4.5, 0.5, 0.5, 1, 0.2, 1, 720])


save("MasterThesisRQA/Data/data.jld2", "healthy", healthy, "schizophrenia", schizophrenia, "bipolar", bipolar, "bereavement", bereavement) 