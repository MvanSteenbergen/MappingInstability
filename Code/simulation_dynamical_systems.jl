using CairoMakie
using DataFrames
using DifferentialEquations
using Distributions
using DynamicalSystems
using Random
using RecurrenceAnalysis
using Statistics

## DATA GENERATION

"""
    threePlusOneDimensions!(du, u, p, t)
    
This function implements the 3 + 1 Dimensions Model. Please check the paper for details (can be found here:
    https://www.frontiersin.org/articles/10.3389/fpsyg.2023.1099257/full). 

    # Arguments
    - 'du' = : The derivatives of the functions x, y, z, f
    - 'u' = : The functions x, y, z, f
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
    integrator.p[14] = clamp(rand(Normal(0, 0.5)), -1.0, 1.0)
    return nothing
end

# Implementation of the periodic callback that uses the affect function above to update the value of ζ in threePlusOneDimensions every 0.01 t.
cb = PeriodicCallback(affect!, 0.01)

# Function to reduce the number of timepoints in the data
# Reduction factor is the kth element to keep (refer to proposal)
function reduceTimepoints(data, reductionFactor)
    # Return every reductionFactor-th element of the data, starting from the first element
    return data[1:reductionFactor:end]
end

# Calculation of the trajectory based on the rules above and return it as a statespaceset
function calculateTrajectory(p₀)
    u₀ = [0.0, 0.01, 0.0, 0.0]
    prob = ODEProblem(threePlusOneDimensions!, u₀, (0.0,12000.0), p₀)
    data = solve(prob, Tsit5(), callback = cb, reltol = 1e-9, abstol = 1e-9, saveat = 0.01)
    data = unique(DataFrame(data))
    data = StateSpaceSet(data[:,2])

    # Initially reduce the data set so that each points reflects one measurement per day
    data = reduceTimepoints(data, 100)
    return data
end

# Set the starting conditions and parameters of the model, and calculate the trajectory.
# I strongly recommend only running one at a time, to avoid running out of memory
healthy = calculateTrajectory([10, 1, 0.1, 14, 10, 1.04, 0.05, 0.2, 14, 4, 0.5, 0.5, 1, 0.2, 1, 720])
schizophrenia = calculateTrajectory([10, 1, 0.1, 14, 10, 0.904, 0.05, 0.2, 14, 4, 0.5, 0.5, 1, 0.2, 1, 720])
bipolar = calculateTrajectory([10, 1, 0.1, 14, 10, 1.04, 0.05, 1.01, 14, 10, 0.5, 0.5, 1, 0.2, 1, 720])
bereavement = calculateTrajectory([10, 1, 0.1, 14, 10, 1, 0.05, 0.6, 14, 4.5, 0.5, 0.5, 1, 0.2, 1, 720])

reduced = reduceTimepoints(healthy, 256)

# Plot and calculate the recurrence statistics

# Function to bin the data into a specified number of bins
function binData(data, n)
    # Calculate the bin size based on the range of the data and the number of bins
    bin_size = (maximum(data) - minimum(data)) / n
    # Bin the data by rounding down the data value to the nearest bin edge
    binned_data = floor.(data / bin_size) * bin_size
    # Return the binned data
    return binned_data
end

# Function to reduce the number of timepoints in the data
function reduceTimepoints(data, reductionFactor)
    # Return every reductionFactor-th element of the data, starting from the first element
    return data[1:reductionFactor:end]
end

# Function to degrade the data by binning it and reducing the number of timepoints
function degradeData(data, segmentN, reductionFactor)
    # Bin the data into segmentN bins
    reduced = binData(data, segmentN)
    # Remove unwanted timepoints and return the reduced data
    return reduceTimepoints(reduced, reductionFactor)
end   

binData(healthyX, 5)

function calculateRecurrenceIndicators()
    
end

# Calculate the recurrence matrix for the data
healthyRM = RecurrenceMatrix(healthy, 0.1)
schizophreniaRM = RecurrenceMatrix(schizophrenia, 0.1) 
bipolarRM = RecurrenceMatrix(bipolar, 0.1)
bereavementRM = RecurrenceMatrix(bereavement, 0.1)

# Make plot 


# Do RQA
healthyRQA = rqa(healthyRM)
schizophreniaRQA = rqa(schizophreniaRM)
bipolarRQA = rqa(bipolarRM)
bereavementRQA = rqa(bereavementRM)


