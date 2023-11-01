using CairoMakie
using DataFrames
using DifferentialEquations
using Distributions
using DynamicalSystems
using Random
using Statistics

## DATA GENERATION

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
    Smax, Rₛ, λₛ, τx, P, Rᵦ, λᵦ, L, τᵧ, S, α, β, τz, ζ = p
    du[1] = (Smax /(1 + exp((Rₛ - u[2]) / λₛ)) - u[1]) / τx
    du[2] = (P / (1 + exp((Rᵦ - u[2]) / λᵦ)) + L - u[1] * u[2] - u[3]) / τᵧ
    du[3] = (S * (α * u[1] + β * u[2]) * ζ - u[3]) / τz
    return nothing
end 

function affect!(integrator)
    integrator.p[14] = rand(Normal(0, 0.5))
    if integrator.p[14] > 1
        integrator.p[14] = 1.0
    else integrator.p[14] < -1
        integrator.p[14] = -1.0
    end
    return nothing
end

cb = PeriodicCallback(affect!, 0.01)

function calculateTrajectory(p₀)
    u₀ = [0.0, 0.1, 0.0]
    prob = ODEProblem(threePlusOneDimensions!, u₀, (0.0,8000.0), p₀)
    X = solve(prob, callback=cb, reltol = 1e-9, abstol = 1e-9)
    return X
end

# Set the starting conditions and parameters of the model
healthy = calculateTrajectory([10, 1, 0.1, 14, 10, 1.04, 0.05, 0.2, 14, 4, 0.5, 0.5, 1, 0.2])
schizophrenia = calculateTrajectory([10, 1, 0.1, 14, 10, 0.904, 0.05, 0.2, 14, 4, 0.5, 0.5, 1, 0.2])
bipolar = calculateTrajectory([10, 1, 0.1, 14, 10, 1.04, 0.05, 1.01, 14, 10, 0.5, 0.5, 1, 0.2])
bereavement = calculateTrajectory([10, 1, 0.1, 14, 10, 1, 0.05, 0.6, 14, 4.5, 0.5, 0.5, 1, 0.2])

## DATA DEGRADATION

# The method takes 



function degradeData(data, segmentN, reductionFactor)
    segmentLength = (maximum(data.Lx) - minimum(data.Lx)) / segmentN

    # Take the modulus and remove it from the values
    data.x = [data.Lx[i] - mod(data.Lx[i], segmentLength) for i in 1:length(data.Lx)]

    # Remove unwanted timepoints and return
    return reduceTimepoints(data, reductionFactor)
end