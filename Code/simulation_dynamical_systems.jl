using CairoMakie
using DataFrames
using DynamicalSystems
using Random
using Statistics

"""
    threePlusOneDimensionsRule!(du, u, p, t)

    
This function implements the 3 + 1 Dimensions Model from the paper 

    # Arguments
    - 'du' = : The derivatives in the order 
"""
function threePlusOneDimensionsRule!(du, u, p, t)

    Smax, τx, τy, τz, τf, α, β, P, S, Rₛ, L, λᵦ, λₛ = p

    a = 2 * (rand() - 0.5)

    du[1] = (Smax /(1 + exp((Rₛ - u[2]) / λₛ)) - u[1]) / τx
    du[2] = (P / (1 + exp((Rₛ - u[2]) / λₛ)) + u[4] * L - u[1] * u[2] - u[3]) / τy
    du[3] = (S * (α * u[1] + β * u[2]) * a - u[3]) / τz
    du[4] = (u[2] - λᵦ * u[4]) / τf

    return nothing
end

"""
    reduceTimepoints(data, reductionFactor)

This simple function reduces the number of timepoints in a time series 
    by taking the modulus of the reduction factor and 
"""
function reduceTimepoints(data, reductionFactor)
    data = filter(:Li => x -> x % reductionFactor == 0, data)
    data.Li = 1:nrow(data)
    return data
end

"""
    degradeData(data, segmentN, reductionFactor)


TBW
"""
function degradeData(data, segmentN, reductionFactor)
    segmentLength = (maximum(data.Lx) - minimum(data.Lx)) / segmentN

    # Take the modulus and remove it from the values
    data.Ax = [data.Lx[i] - mod(data.Lx[i], segmentLength) for i in 1:length(data.Lx)]

    # Remove unwanted timepoints and return
    return reduceTimepoints(data, reductionFactor)
end

# Set the starting conditions and parameters of the model
p₀ = [10, 14, 14, 2, 1, 0.5, 0.5, 10, 10, 1, 1.01, 0.05, 0.1]
u₀ = [0.0, 0.1, 0.0, 0.0]

# Save the threePlusOneDimensions as a Dynamical Systems object using the rule
threePlusOneDimensions = CoupledODEs(threePlusOneDimensionsRule!, u₀, p₀)

# Settings
totalTime = 20
samplingTime = 0.5

# Calculate trajectory over 
Y,t = trajectory(threePlusOneDimensions, Ttr = 15, totalTime, Δt = samplingTime)

# Create figure
fig = Figure()

ax = Axis(fig[1, 1]; xlabel = "time", ylabel = "variable")

for var in columns(Y)
    lines!(ax, t, var)
end

fig[1, 2] = Legend(fig, ax, "Variables", framevisible = false)

fig

# Split columns
x, y, z, f = columns(Y)

# Create recurrenceplot
R = recurrenceplot(threePlusOneDimensions)
Rg = grayscale(R)
rr = recurrencerate(R)

# Plot heatmap
heatmap(Rg; colormap = :grays,
    axis = (title = "recurrence rate = $(rr)", aspect = 1)
)

# Create dataframe
