using CairoMakie
using RecurrenceAnalysis
using Statistics
using JLD2

healthy, schizophrenia, bipolar, bereavement = load("MasterThesisRQA/Data/data.jld2", "healthy", "schizophrenia", "bipolar", "bereavement")


# Function to bin the data into a specified number of bins
function binData(data, n)
    # Calculate the bin size based on the range of the data and the number of bins
    bin_size = (maximum(data) - minimum(data)) / n
    # Bin the data by rounding down the data value to the nearest bin edge
    binned_data = floor.(data / bin_size) * bin_size
    # Return the binned data
    return binned_data, bin_size
end

# Function to reduce the number of timepoints in the data
function reduceTimepoints(data, reductionFactor)
    # Return every reductionFactor-th element of the data, starting from the first element
    return data[1:reductionFactor:end]
end

# Function to degrade the data by binning it and reducing the number of timepoints
function degradeData(data, segmentN, reductionFactor)
    # Bin the data into segmentN bins
    reduced, bin_size = binData(data, segmentN)
    # Remove unwanted timepoints and return the reduced data
    return reduceTimepoints(reduced, reductionFactor), bin_size
end   

function calculateRQA(data, segmentN, reductionFactor)
    segment, bin_size = degradeData(data, segmentN, reductionFactor)
    rqa_calc = rqa(RecurrenceMatrix(segment, bin_size))
    return [segmentN, reductionFactor, collect(values(rqa_calc))...]
end

function runSimulationStudy(data)
    # get colnames from data (very compactly written, converts keys to an array))
    convert_names = [String(i) for i in collect(keys(rqa((RecurrenceMatrix(data, 100)))))]
    # save the colnames of the dataframe as array
    colnames = ["segmentN", "reductionFactor", convert_names...]
    #  Create empty dataframe using colnames
    simulation = DataFrame([name => [] for name in colnames])
    # Iterate over all conditions and save those to dataframe
    for segment_n in [100, 20, 7, 6, 5, 4, 3, 2]
        for reduction_factor in [8, 4, 2, 1]
            push!(simulation, calculateRQA(data, segment_n, reduction_factor))
        end
    end
    # Return the simulations
    return simulation
end

function createPlots(data)
    plots = Array{Any}(nothing, 32)
    idx = 1
    for segment_n in [100, 20, 7, 6, 5, 4, 3, 2]
        for reduction_factor in [8, 4, 2, 1]
            object, bin_size = degradeData(data, segment_n, reduction_factor)
            plot(RecurrenceMatrix(object, bin_size), title="$(segment_n) segments, reduction factor $(reduction_factor)")
        end
    end
    return nothing
end

ss_healthy = runSimulationStudy(healthy.value1)
ss_schizophrenia = runSimulationStudy(schizophrenia.value1)
ss_bipolar = runSimulationStudy(bipolar.value1)
ss_bereavement = runSimulationStudy(bereavement.value1)

plot = createPlots(healthy.value1)

save("MasterThesisRQA/Data/simulation_studies.jld2", "ss_healthy", ss_healthy, "ss_schizophrenia", ss_schizophrenia, "ss_bipolar", ss_bipolar, "ss_bereavement", ss_bereavement)

data = RecurrenceMatrix(healthy.value1, 0.1)
plot(data)

data, degraded = degradeData(healthy.value1, 7, 4)

plot(RecurrenceMatrix(data, 0.05))

data