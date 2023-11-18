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
    rm = RecurrenceMatrix(segment, (reductionFactor*0.1))
    return rqa(rm)
end


function runSimulationStudy(data)
    save = []
    for segmentN in [100, 20, 7, 6, 5, 4, 3, 2]
        for reductionFactor in [8, 4, 2, 1]
            save.append(calculateRQA(data, segmentN, reductionFactor))
        end
    end
    return save
end

plot(healthy)

# Calculate the recurrence matrix for the data
healthyRM = RecurrenceMatrix(healthy, 0.1)
schizophreniaRM = RecurrenceMatrix(schizophrenia, 0.1) 
bipolarRM = RecurrenceMatrix(bipolar, 0.1)
bereavementRM = RecurrenceMatrix(bereavement, 0.1)

runSimulationStudy(healthyRM)

# Do RQA
healthyRQA = rqa(healthyRM)
schizophreniaRQA = rqa(schizophreniaRM)
bipolarRQA = rqa(bipolarRM)
bereavementRQA = rqa(bereavementRM)