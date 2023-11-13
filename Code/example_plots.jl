using RecurrenceAnalysis, DelayEmbeddings, CairoMakie
CairoMakie.activate!()
# A simple sine wave (based on https://juliadynamics.github.io/RecurrenceAnalysis.jl/v2.0/rplots/)

data = sin.(2*π.* (0:400)./ 60)
Y = embed(data, 3, 15)
R = RecurrenceMatrix(data, 0.1)

fig = Figure(resolution = (1000,1000), fontsize = 40)
ax = Axis(fig[1, 1]; title = "Recurrence plot for a simple sinus wave")
heatmap!(ax, grayscale(R))
fig



rqa(R)

function dampedOscillationsRule!()