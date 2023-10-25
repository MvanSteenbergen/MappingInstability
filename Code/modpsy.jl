using Gadfly
using DataFrames
using Random
using RecurrenceAnalysis

# DATA GENERATION
function generateData(Smax, Rs, λs, τx, P, Rb, λb, L, τy, S, α, β, τz)
    Li = collect(1:100000)
    δt = 0.01
    Lt = [δt * i for i in Li]
    y, x, z, f = 0.01, 0.0, 0.0, 0.0
    Ly = []
    Lx = []
    Lz = []
    Lf = []

    for i in Li
        a = rand() - 0.5
        
        δx = (Smax /(1 + exp((Rs - y) / λs)) - x) / τx
        δy = (P / (1 + exp((Rb - y) / λb)) + L * f - x * y - z) 
        δz = (S * (α * x + β * y) * a - z) / τz
        δf = (y - 1.0 * f) / 720

        y = y + δy * δt 
        x = x + δx * δt
        z = z + δz * δt
        f = f + δf * δt

        push!(Ly, y)
        push!(Lx, x)
        push!(Lz, z)
        push!(Lf, f)
    end

    return DataFrame(Ly = Ly, Lx = Lx, Lz = Lz, Lf = Lf, Lt = Lt)
end

# Timepoint reduction function
function reduceTimepoints(data, tReduction)
    index = floor(range(1, nrow(data), tReduction))
    return data[index]
end

# Data degredation for experiment
function degradeData(data, segmentN, tReduction)
    segmentLength = (maximum(data.Lx) - minimum(data.Lx)) / segmentN

    # Take the modulus and remove it from the values
    data.Ax = [data.Lx[i] - mod(data.Lx[i], segmentLength) for i in 1:length(data.Lx)]

    # Remove unwanted timepoints and return
    return reduceTimepoints(data, tReduction)
end

# Calculation of recurrence indicators
function recurrenceStatistics
    recurrence

data = generateData(10, 1, 0.1, 14, 10, 1.04, 0.05, 1.01, 14, 10, 0.5, 0.5, 1)

