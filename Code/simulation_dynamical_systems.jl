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

function calculateRQA(data, segmentN, reductionFactor)
    segment = degradeData(data, segmentN, reductionFactor)
    rqa_calc = rqa(RecurrenceMatrix(segment, 0.1))
    return [segmentN, reductionFactor, collect(values(rqa_calc))...]
end


function runSimulationStudy(data)
    # get colnames from data
    findNames = [String(i) for i in collect(keys(rqa((RecurrenceMatrix(data, 100)))))]
    colnames = ["segmentN", "reductionFactor", findNames...]
    save = DataFrame([name => [] for name in colnames])
    for segmentN in [100, 20, 7, 6, 5, 4, 3, 2]
        for reductionFactor in [8, 4, 2, 1]
            push!(save, calculateRQA(data, segmentN, reductionFactor))
        end
    end
    return save
end


ss_healthy = runSimulationStudy(healthy.value1)
ss_schizophrenia = runSimulationStudy(schizophrenia.value1)
ss_bipolar = runSimulationStudy(bipolar.value1)
ss_bereavement = runSimulationStudy(bereavement.value1)
