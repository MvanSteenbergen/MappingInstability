using RecurrenceAnalysis, DelayEmbeddings, CairoMakie, JLD2, RecurrenceAnalysis


CairoMakie.activate!(type = "png", px_per_unit = 10.0)
healthy, schizophrenia, bipolar, bereavement = load("MasterThesisRQA/Data/data.jld2", "healthy", "schizophrenia", "bipolar", "bereavement")

## Figure 1.
f1 = Figure(backgroundcolor = RGBf(0.98, 0.98, 0.98),
    resolution = (1200, 800))
ax1 = Axis(f1[1,1],
    title = "Healthy",
    xlabel = "Days [t]",
    ylabel = "Symptom Intensity [x]")
x_healthy = healthy.value1
y_healthy = healthy.timestamp
lines!(ax1, y_healthy, x_healthy)
    
ax2 = Axis(f1[1,2],
    title = "Schizophrenia",
    xlabel = "Days [t]",
    ylabel = "Symptom Intensity [x]")
x_schizophrenia = schizophrenia.value1
y_schizophrenia = schizophrenia.timestamp
lines!(ax2, y_schizophrenia, x_schizophrenia)
hideydecorations!(ax2, grid = false)

ax3 = Axis(f1[2,1],
    title = "Bipolar Disorder",
    xlabel = "Days [t]",
    ylabel = "Symptom Intensity [x]")
x_bipolar = bipolar.value1
y_bipolar = bipolar.timestamp
lines!(ax3, y_bipolar, x_bipolar)

ax4 = Axis(f1[2,2],
    title = "Bereavement Disorder",
    xlabel = "Days [t]",
    ylabel = "Symptom Intensity [x]")
x_bereavement = bereavement.value1
y_bereavement = bereavement.timestamp
lines!(ax4, y_bereavement, x_bereavement)
hideydecorations!(ax4, grid = false)
linkaxes!(ax1, ax2, ax3, ax4)

supertitle = f1[0, :] = Label(f1, "Time Series Generated Using the 3 + 1 Dimensions Model", font = :bold, fontsize = 24)

resize_to_layout!(f1)

f1
f2 = Figure(backgroundcolor = RGBf(0.98, 0.98, 0.98),
    resolution = (1000, 1000))

# Kinda cheating here, if there's only one value it picks the half-way point of the gradient, so I had to pick a different color scheme to make it work
ax5 = Axis(f2[1,1],
    title = "Healthy")
plot!(ax5, RecurrenceMatrix(healthy.value1, 0.2), colormap=:lisbon100)

ax6 = Axis(f2[1,2], 
    title = "Schizophrenia")
plot!(ax6, RecurrenceMatrix(schizophrenia.value1, 0.2), colormap=Reverse(:greys))

ax7 = Axis(f2[2,1],
    title = "Bipolar Disorder")
plot!(ax7, RecurrenceMatrix(bipolar.value1, 0.2), colormap=Reverse(:greys))

ax8 = Axis(f2[2,2],
    title = "Bereavement Disorder")
plot!(ax8, RecurrenceMatrix(bereavement.value1, 0.2), colormap=Reverse(:greys))

hidedecorations!(ax6, grid = false)
hidexdecorations!(ax5, grid = false)
hideydecorations!(ax8, grid = false)

supertitle = f2[0, :] = Label(f2, "Recurrence Plot for the Four Generated Trajectories", font = :bold, fontsize = 24)
f2

#Figure 2
