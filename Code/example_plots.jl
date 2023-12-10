using RecurrenceAnalysis, DelayEmbeddings, CairoMakie
# A simple sine wave (based on https://juliadynamics.github.io/RecurrenceAnalysis.jl/v2.0/rplots/)

healthy, schizophrenia, bipolar, bereavement = load("MasterThesisRQA/Data/data.jld2", "healthy", "schizophrenia", "bipolar", "bereavement")
plot(healthy.value1)

function binData(data, n)
    # Calculate the bin size based on the range of the data and the number of bins
    bin_size = (maximum(data) - minimum(data)) / n
    # Bin the data by rounding down the data value to the nearest bin edge
    binned_data = floor.(data / bin_size) * bin_size
    # Return the binned data
    return binned_data, bin_size
end


function reduceTimepoints(data, reductionFactor)
    # Return every reductionFactor-th element of the data, starting from the first element
    return data[1:reductionFactor:end]
end


degraded, size = binData(healthy.value1, 7)
plot(degraded)

reduced = reduceTimepoints(degraded, 8)
plot(reduced)