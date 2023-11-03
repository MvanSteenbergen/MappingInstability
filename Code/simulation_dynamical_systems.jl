using CairoMakie
using DataFrames
using DifferentialEquations
using Distributions
using DynamicalSystems
using Random
using Statistics
using Sundials

## DATA GENERATION

"""
    threePlusOneDimensions!(du, u, p, t)
    
This function implements the 3 + 1 Dimensions Model. Please check the paper for details (can be found here:
    https://www.frontiersin.org/articles/10.3389/fpsyg.2023.1099257/full). 

    # Arguments
    - 'du' = : The derivatives of the functions x, y, z, f
    - 'u' = : The functions x, y, z
    - 'p' = : Parameters Smax, Rₛ, λₛ, τx, P, Rᵦ, λᵦ, L, τᵧ, S, α, β, τz, ζ 
    - 't' = : Used by ODEProblem function. Does something under the hood.
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
    integrator.p[14] = rand(Normal(0, 0.5))
    if integrator.p[14] > 1
        integrator.p[14] = 1.0
    elseif  integrator.p[14] < -1
        integrator.p[14] = -1.0
    end
    return nothing
end

# Implementation of the periodic callback that uses the affect function above to update the value of ζ in threePlusOneDimensions every 0.01 t.
cb = PeriodicCallback(affect!, 0.01)

# Calculation of the trajectory based on the rules above
function calculateTrajectory(p₀)
    u₀ = [0.0, 0.01, 0.0, 0.0]
    prob = ODEProblem(threePlusOneDimensions!, u₀, (0.0,6000.0), p₀)
    X = solve(prob, CVODE_BDF(), callback=cb, reltol = 1e-9, abstol = 1e-9)
    return X
end

function keepX(data)
    return [i[1] for i in data.u]
end

# Set the starting conditions and parameters of the model, and calculate the trajectory
healthy = calculateTrajectory([10, 1, 0.1, 14, 10, 1.04, 0.05, 0.2, 14, 4, 0.5, 0.5, 1, 0.2, 1, 720])
schizophrenia = calculateTrajectory([10, 1, 0.1, 14, 10, 0.904, 0.05, 0.2, 14, 4, 0.5, 0.5, 1, 0.2, 1, 720])
bipolar = calculateTrajectory([10, 1, 0.1, 14, 10, 1.04, 0.05, 1.01, 14, 10, 0.5, 0.5, 1, 0.2, 1, 720])
bereavement = calculateTrajectory([10, 1, 0.1, 14, 10, 1, 0.05, 0.6, 14, 4.5, 0.5, 0.5, 1, 0.2, 1, 720])

# Only save the x's from the model
healthyX = keepX(healthy)
schizophreniaX = keepX(schizophrenia)
bipolarX = keepX(bipolar)
bereavementX = keepX(bereavement)

function binData(data, n)
    # Calculate the bin size
    bin_size = (maximum(data) - minimum(data)) / n
    # Bin the data
    data = [value - mod(value, bin_size) for value in data]
    # Return the binned data
    return data
end

function reduceEachKthTimepoint(data, reductionFactor)
    reduced = [data...]
    keepat!(reduced, 1:reductionFactor:length(data))
end

function degradeData(data, segmentN, reductionFactor)
    reduced = binData(data, segmentN)
    # Remove unwanted timepoints and return
    return reduceTimepoints(reduced, reductionFactor)
end   
 
binData(healthyX, 5)
