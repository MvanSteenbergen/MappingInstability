### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 33346680-f0d0-11ee-360d-7f79d033e3da
begin
	using CSV
	using Pipe
	using CairoMakie
	using DataFrames
	using FileIO
end

# ╔═╡ 75ec7454-2760-4e2e-9016-509fce4b2ca1
md"""
Copyright 2024 Maas van Steenbergen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"""

# ╔═╡ 0f32e5ae-a6bf-453d-beef-530c6ba6c654
md"""
# Plots and analysis

This file contains all of the code for my plots and the analysis that were necessary for the `Mapping Instability of Response Categories' study.

Makie is used as the plotting environment. Information about makie can be found [here](https://docs.makie.org/stable/).

Nothing additional needs to be done to install the packages. Pluto will automatically create an environment and install compatible versions of the packages using the package manager. Version numbers are included in the footer of this document - they can be found by opening the .jl analysis file in VSCode or notepad.
"""

# ╔═╡ 8f916ee1-36ed-4d0b-af74-4a3eee70576b
md"""
## Data loading
"""

# ╔═╡ 067cee09-2883-4013-b21c-7808102a4328
begin
	df = CSV.File("../Data/random_diff_data.csv")
	df = DataFrame(df)
	CairoMakie.activate!(type = "png")
end

# ╔═╡ 25c9c157-c116-43d1-87dc-6e298537987f
df

# ╔═╡ 4df00c27-8a97-442f-84f5-11a342ed380c
begin
	group_based = CSV.File("../Data/group_diff_data.csv")
	group_based = DataFrame(group_based)
end

# ╔═╡ aff7cb92-72b8-4e79-9b51-f4b1e442951a
md"""
## Data Pre-Processing

In this section we pre-process data by setting two or three of the variables in the dataset to a default, and letting the other variables vary freely. 

This allows us to plot the behaviour of either one variable or two variables by themselves, with the other values `locked' to a sensibly set default.
"""

# ╔═╡ 0881b78e-ae10-4277-9bfb-26f7ac68512c
begin
	onlyIntervals = @pipe df |>
		filter(row -> row[:th_σ] === 0.0, _) |>
		filter(row -> row[:lbr_σ] === 0.0, _) |>
		filter(row -> row[:rbr_σ] === 0.0, _) 

	onlyLbr = @pipe df |>
		filter(row -> row[:th_σ] === 0.0, _) |>
		filter(row -> row[:nIntervals] === 100, _) |>
		filter(row -> row[:rbr_σ] === 0.0, _)

	onlyRbr = @pipe df |>
		filter(row -> row[:th_σ] === 0.0, _) |>
		filter(row -> row[:nIntervals] === 100, _) |>
		filter(row -> row[:lbr_σ] === 0.0, _)

	onlyα = @pipe df |>
		filter(row -> row[:nIntervals] === 100, _) |>
		filter(row -> row[:rbr_σ] === 0.0, _) |>
		filter(row -> row[:lbr_σ] === 0.0, _)

	intervalAndLbr = @pipe df |>
		filter(row -> row[:th_σ] === 0.0, _) |>
		filter(row -> row[:rbr_σ] === 0.0, _) 

	intervalAndRbr = @pipe df |> 
		filter(row -> row[:th_σ] === 0.0, _) |>
		filter(row -> row[:lbr_σ] === 0.0, _) 

	intervalAndThα = @pipe df |> 
		filter(row -> row[:rbr_σ] === 0.0, _)  |>
		filter(row -> row[:lbr_σ] === 0.0, _)  

	lbrAndRbr = @pipe df |>
		filter(row -> row[:th_σ] === 0.0, _) |>
		filter(row -> row[:nIntervals] === 100, _) 

	lbrAndThα = @pipe df |>
		filter(row -> row[:rbr_σ] === 0.0, _)  |>
		filter(row -> row[:nIntervals] === 100, _)
	
	rbrAndThα = @pipe df |>
		filter(row -> row[:lbr_σ] === 0.0, _)  |>
		filter(row -> row[:nIntervals] === 100, _) 	
end

# ╔═╡ cb50185d-9dc8-4201-a1a7-fc4392bc1dc7
begin
	onlyIntervals_gb = @pipe group_based |>
		filter(row -> row[:th_α] === 0.0, _) |>
		filter(row -> row[:lbr_σ] === -3.0, _) |>
		filter(row -> row[:rbr_σ] === 6.0, _) 

	onlyLbr_gb = @pipe group_based |>
		filter(row -> row[:th_α] === 0.0, _) |>
		filter(row -> row[:nIntervals] === 100, _) |>
		filter(row -> row[:rbr_σ] === 6.0, _)

	onlyRbr_gb = @pipe group_based |>
		filter(row -> row[:th_α] === 0.0, _) |>
		filter(row -> row[:nIntervals] === 100, _) |>
		filter(row -> row[:lbr_σ] === -3.0, _)

	onlyα_gb = @pipe group_based |>
		filter(row -> row[:nIntervals] === 100, _) |>
		filter(row -> row[:rbr_σ] === 6.0, _) |>
		filter(row -> row[:lbr_σ] === -3.0, _)

	intervalAndLbr_gb = @pipe group_based |>
		filter(row -> row[:th_α] === 0.0, _) |>
		filter(row -> row[:rbr_σ] === 6.0, _) 

	intervalAndRbr_gb = @pipe group_based |> 
		filter(row -> row[:th_α] === 0.0, _) |>
		filter(row -> row[:lbr_σ] === -3.0, _) 

	intervalAndThα_gb = @pipe group_based |> 
		filter(row -> row[:rbr_σ] === 6.0, _)  |>
		filter(row -> row[:lbr_σ] === -3.0, _)  |>
		filter(row -> row[:th_α] !== 0.0, _)

	lbrAndRbr_gb = @pipe group_based |>
		filter(row -> row[:th_α] === 0.0, _) |>
		filter(row -> row[:nIntervals] === 100, _) 

	lbrAndThα_gb = @pipe group_based |>
		filter(row -> row[:rbr_σ] === 6.0, _)  |>
		filter(row -> row[:nIntervals] === 100, _) |>
		filter(row -> row[:th_α] !== 0.0, _)

	rbrAndThα_gb = @pipe group_based |>
		filter(row -> row[:lbr_σ] === -3.0, _)  |>
		filter(row -> row[:nIntervals] === 100, _) |>
		filter(row -> row[:th_α] !== 0.0, _)
	
end

# ╔═╡ 6ed60b8f-bb14-4fad-ba41-723b8700ad42
md"""
## Random Mapping Instability Effects Type-I/Power

The first plot shows different aspects of the effect of random mapping instability on empirical power and Type I error rates. With random mapping instability, all mapings vary randomly between participants, but do not vary by group. The plot includes visualizations for zero-point instability, scaling instability, and systematic threshold instability, comparing a type of mapping instability with the value of a default without mapping instability.
"""

# ╔═╡ 1f986790-6f45-4ccb-a9fd-3449f895538f
begin
	f1 = Figure(size = (1600, 1600))

	## SET UP THE GRID LAYOUT
	title = f1[1, 1:3] = GridLayout()

	illustrationheader = f1[2, 1] = GridLayout()
	powerheader = f1[2, 2] = GridLayout()
	errorheader = f1[2, 3] = GridLayout()

	subtitle2 = f1[3, 1:3] = GridLayout()
	
	l2 = f1[4, 1] = GridLayout()
	m2 = f1[4, 2] = GridLayout()
	r2 = f1[4, 3] = GridLayout()

	subtitle3 = f1[5, 1:3] = GridLayout()

	l3 = f1[6, 1] = GridLayout()
	m3 = f1[6, 2] = GridLayout()
	r3 = f1[6, 3] = GridLayout()

	subtitle4 = f1[7, 1:3] = GridLayout()
	
	l4 = f1[8, 1] = GridLayout()
	m4 = f1[8, 2] = GridLayout()
	r4 = f1[8, 3] = GridLayout()

	## SET UP THE AXES FOR THE PLOTTING
	img1 = rotr90(load("../Diagrams/zeropointinstability_random.png"))
	img2 = rotr90(load("../Diagrams/scalinginstability_random.png"))
	img3 = rotr90(load("../Diagrams/thresholdinstability_random.png"))

	AxisM2 = Axis(l2[1,1], aspect = DataAspect())
	AxisM3 = Axis(l3[1,1], aspect = DataAspect())
	AxisM4 = Axis(l4[1,1], aspect = DataAspect())

	AxisL2 = Axis(m2[1,1], xlabel = "Zero-point instability \n σ of Normal (-3, σ) → cₚ", ylabel = "Empirical power (α ⩵ 0.05)", ylabelsize = 20, xlabelsize = 20)
	AxisL3 = Axis(m3[1,1], xlabel = "Scaling instability \n σ of Normal (6, σ) → xₚ", ylabel = "Empirical power (α ⩵ 0.05)", xlabelsize = 20, ylabelsize = 20)
	AxisL4 = Axis(m4[1,1], xlabel = "Threshold instability \n σ of Normal (0, σ) → Kₚₜ", ylabel = "Empirical power (α ⩵ 0.05)", xlabelsize = 20, ylabelsize = 20)

	image!(AxisM2, img1)
	image!(AxisM3, img2)
	image!(AxisM4, img3)
	
	AxisR2 = Axis(r2[1,1], xlabel = "Zero-point instability \n σ of Normal (-3, σ) → cₚ", ylabel = "Empirical Type I error rate (α ⩵ 0.05)", ylabelsize = 20, xlabelsize = 20)
	AxisR3 = Axis(r3[1,1], xlabel = "Scaling instability \n σ of Normal (6, σ) → xₚ", ylabel = "Empirical Type I error rate (α ⩵ 0.05)", ylabelsize = 20, xlabelsize = 20)
	AxisR4 = Axis(r4[1,1], xlabel = "Threshold instability \n σ of Normal (0, σ) → α, β", ylabel = "Empirical Type I error rate (α ⩵ 0.05)", ylabelsize = 20, xlabelsize = 20)

	## ADD LABELS
	Label(title[1,1], "Experiment 1: \n Effect of Random Mapping Instability on Empirical Power and Type I Error", fontsize = 34, font = :bold, halign = :center)
	Label(illustrationheader[1,1], fontsize = 24, "Type of Parameter", font = :bold_italic)
	Label(powerheader[1,1], fontsize = 24, "Empirical Power", font = :bold_italic)
	Label(errorheader[1,1], fontsize = 24, "Type I Error Rate", font = :bold_italic)

	Label(subtitle2[1,1], "Zero-Point Instability", fontsize = 24, font = :bold, halign = :left)
	Label(subtitle3[1,1], "Scaling Instability", fontsize = 24, font = :bold, halign = :left)
	Label(subtitle4[1,1], "Systematic Threshold Instability", fontsize = 24, font = :bold, halign = :left)

	# LINK THE LABEL AXES SO THEY ARE ON THE SAME SCALE
	linkxaxes!(AxisL2, AxisR2)
	linkxaxes!(AxisL3, AxisR3)
	linkxaxes!(AxisL4, AxisR4)

	linkyaxes!(AxisL2, AxisL3, AxisL4, AxisR2, AxisR3, AxisR4)

	## ADD THE RESULTS FOR THE UNMAPPED DATA
	hlines!(AxisL2, 0.832, color = :cyan3, label = "Power for stable mapping")
	hlines!(AxisR2, 0.05, color = :cyan3, label = "Type I for stable mapping")
	hlines!(AxisL3, 0.832, color = :cyan3)
	hlines!(AxisR3, 0.05, color = :cyan3)
	hlines!(AxisL4, 0.832, color = :cyan3)
	hlines!(AxisR4, 0.05, color = :cyan3)


	## ADD THE RESULTS FROM THE DATA
	scatterlines!(AxisL2, onlyRbr.rbr_σ, onlyRbr.Power, color = :blue, label = "Power for unstable mapping")
	errorbars!(AxisL2,onlyRbr.rbr_σ, onlyRbr.Power, 1.96*onlyRbr.Power_SDE, whiskerwidth = 8, color = :red)
	
	scatterlines!(AxisR2, onlyRbr.rbr_σ, onlyRbr.TypeI, color = :blue, label = "Type I for unstable mapping")
	errorbars!(AxisR2, onlyRbr.rbr_σ, onlyRbr.TypeI, 1.96*onlyRbr.TypeI_SDE, whiskerwidth = 8, color = :red)

	scatterlines!(AxisL3, onlyLbr.lbr_σ, onlyLbr.Power, color = :blue)
	errorbars!(AxisL3, onlyLbr.lbr_σ, onlyLbr.Power, 1.96*onlyLbr.Power_SDE, whiskerwidth = 8, color = :red)
	
	scatterlines!(AxisR3, onlyLbr.lbr_σ, onlyLbr.TypeI, color = :blue)
	errorbars!(AxisR3, onlyLbr.lbr_σ, onlyLbr.TypeI, 1.96*onlyLbr.TypeI_SDE, whiskerwidth = 8, color = :red)

	scatterlines!(AxisL4, onlyα.th_σ, onlyα.Power, color = :blue)
	errorbars!(AxisL4, onlyα.th_σ, onlyα.Power, 1.96*onlyα.Power_SDE, whiskerwidth = 8, color = :red)
	
	scatterlines!(AxisR4, onlyα.th_σ, onlyα.TypeI, color = :blue)
	errorbars!(AxisR4, onlyα.th_σ, onlyα.TypeI, 1.96*onlyα.TypeI_SDE, whiskerwidth = 8, color = :red)

	hidedecorations!(AxisM2)
	hidespines!(AxisM2)

	colsize!(f1.layout, 1, Relative(1/3))
	colsize!(f1.layout, 2, Relative(1/3))
	colsize!(f1.layout, 3, Relative(1/3))

	legendheader1 = Legend(f1[9, 2], AxisR2, aspect = :nothing, tellheight = true, labelsize = 20)
	legendheader2 = Legend(f1[9, 3], AxisL2, aspect = :nothing, tellheight = true, labelsize = 20)

	hidedecorations!(AxisM3)
	hidespines!(AxisM3)

	hidedecorations!(AxisM4)
	hidespines!(AxisM4)
	
	f1
end

# ╔═╡ 8bc963a4-25e9-4660-91ec-2f1f76866fa6
md"""
## Number of Categories and Type-I Error Rate/Power
This plot illustrates the impact of varying the number of response categories on the empirical power and Type I error rate. The red bars are the 95% CI error bars.
"""

# ╔═╡ 4bab68ed-c529-4512-84f6-5bd17c3fa8d0
begin
    # Create a new figure with specified size
	f2 = Figure(size = (1000, 500))
	
    # Define title layout
	title1 = f2[1, 1:2]
		
    # Define left and right grids for plots
	m1 = f2[2, 1] = GridLayout()
	r1 = f2[2, 2] = GridLayout()
	
    # Define left and right axes with labels and limits
	AxisL1 = Axis(m1[1,1], xlabel = "Number of response categories", limits = (nothing, nothing, 0, 1), ylabel = "Empirical power (α ⩵ 0.05)", ylabelsize = 16, xlabelsize = 16)
	AxisR1 = Axis(r1[1,1], xlabel = "Number of response categories", limits = (nothing, nothing, 0, 1), ylabel = "Empirical Type I error rate (α ⩵ 0.05)", ylabelsize = 16, xlabelsize = 16)
    
    # Set title for the figure
	Label(title1[1,1], "Effect of the Number of Categories on Type I Error Rate and Power", fontsize = 20, font = :bold)
		
    # Link the x-axes of both plots
	linkxaxes!(AxisL1, AxisR1)
	
    # Add horizontal lines for stable mapping power and Type I error rate
	hlines!(AxisL1, 0.832, color = :cyan3, label = "Power for stable mapping")
	hlines!(AxisR1, 0.05, color = :cyan3, label = "Type I for stable mapping")
	
    # Add scatter plot and error bars for unstable mapping power
	scatterlines!(AxisL1, onlyIntervals.nIntervals, onlyIntervals.Power, color = :blue, label = "Power for unstable mapping: N(0, σ)")
	errorbars!(AxisL1, onlyIntervals.nIntervals, onlyIntervals.Power, 1.96*onlyIntervals.Power_SDE, whiskerwidth = 8, color = :red)
	
    # Add scatter plot and error bars for unstable mapping Type I error rate
	scatterlines!(AxisR1, onlyIntervals.nIntervals, onlyIntervals.TypeI, color = :blue, limits = (nothing, nothing, 0, 1), label = "Type I for unstable mapping: N(0, σ)")
	errorbars!(AxisR1, onlyIntervals.nIntervals, onlyIntervals.TypeI, 1.96*onlyIntervals.TypeI_SDE, whiskerwidth = 8, color = :red)

    # Return the figure
	f2
end

# ╔═╡ 6a0f9b1a-3474-4a1d-9038-18f44d90eea2
md"""
## Two-Way Interactions Mapping Instability Parameters Power

This code generates a series of heatmaps arranged in a grid layout, representing the interactions between different parameters of mapping instability and their effects on empirical power in Experiment 1. The heatmaps visualize how variations in parameters  zero-point instability, scaling instability, and threshold instability impacts the empirical power of a simple t-test.
"""

# ╔═╡ a2a3bf3d-33fb-4b7e-bc97-00b53bb3f902
md"""
## Two-Way Interactions Mapping Instability Parameters Type-I Error

This code generates a series of heatmaps arranged in a grid layout, representing the interactions between different parameters of mapping instability and their effects on the Type-I error rate in Experiment 1. The heatmaps visualize how variations in parameters  zero-point instability, scaling instability, and threshold instability impacts the Type-I error rate of a simple t-test.
"""

# ╔═╡ ca60ad2c-d9c5-420d-a271-825551b3a3dc
begin
    # Create a figure with specified size
	f4 = Figure(size = (900, 900))
	
    # Set up the title grid layout
	title3 = f4[1, 0:3] = GridLayout()
	
    # Set up the subplots grid layouts
	b11 = f4[2, 1] = GridLayout()
	b12 = f4[3, 1] = GridLayout()
	b13 = f4[4, 1] = GridLayout()
	b22 = f4[3, 2] = GridLayout()
	b23 = f4[4, 2] = GridLayout()
	b31 = f4[4, 3] = GridLayout()
	b24 = f4[2:4,0] = GridLayout()

    # Set joint color limits for the heatmap
	joint_limits_2 = (0, 0.8)

    # Set up the color scale for the heatmap
    scale = ReversibleScale(x -> asinh(x / 2) / log(10), x -> 2sinh(log(10) * x))
	
    # Define axes for each subplot
	AxisB11 = Axis(b11[1,1], xlabel = "Zero-point instability \n σ of Normal (-3, σ)",  ylabel = "Number of categories")
	AxisB12 = Axis(b12[1,1], xlabel = "Scaling instability \n σ of Normal (6, σ)", ylabel = "Number of categories")
	AxisB13 = Axis(b13[1,1], xlabel = "Threshold instability \n σ of Normal (0, σ)", ylabel = "Number of categories")

	AxisB22 = Axis(b22[1,1], xlabel = "Scaling instability \n σ of Normal (6, σ)", ylabel = "Zero-point instability \n σ of Normal (-3, σ)")
	AxisB23 = Axis(b23[1,1], xlabel = "Threshold instability\n σ of Normal (0, σ)", ylabel = "Zero-point instability \n σ of Normal (-3, σ)")

	AxisB31 = Axis(b31[1,1], xlabel = "Threshold instability\n σ of Normal (0, σ)", ylabel = "Scaling instability \n σ of Normal (6, σ)")

    # Set the title of the plot
	Label(title3[1,1], "Empirical Type I Error After Changing Measurement Instability Parameters", fontsize = 20, font = :bold, halign = :left)
	
    # Create heatmaps for each subplot
	hmb11 = heatmap!(AxisB11, intervalAndLbr.lbr_σ, intervalAndLbr.nIntervals, intervalAndLbr.TypeI, colorrange = joint_limits_2, colorscale = scale, colormap = Reverse(:roma))
	hmb12 = heatmap!(AxisB12, intervalAndRbr.rbr_σ, intervalAndRbr.nIntervals, intervalAndRbr.TypeI, colorrange = joint_limits_2, colorscale = scale, colormap = Reverse(:roma))
	hmb13 = heatmap!(AxisB13, intervalAndThα.th_σ, intervalAndThα.nIntervals, intervalAndThα.TypeI, colorrange = joint_limits_2, colorscale = scale, colormap = Reverse(:roma))
	
	hmb21 = heatmap!(AxisB22, lbrAndRbr.rbr_σ, lbrAndRbr.lbr_σ, lbrAndRbr.TypeI, colorrange = joint_limits_2, colorscale = scale, colormap = Reverse(:roma))
	hmb22 = heatmap!(AxisB23, lbrAndThα.th_σ, lbrAndThα.lbr_σ, lbrAndThα.TypeI, colorrange = joint_limits_2, colorscale = scale, colormap = Reverse(:roma))

	hmb31 = heatmap!(AxisB31, rbrAndThα.th_σ, rbrAndThα.rbr_σ, rbrAndThα.TypeI, colorrange = joint_limits_2, colorscale = scale, colormap = Reverse(:roma))

    # Add colorbar to the plot
	AxisB33 = Colorbar(b24[1,1], hmb11)

    # Display the figure
	f4
end

# ╔═╡ d3f26221-8558-4e8c-a6da-ac6580ee3b58
begin
# Create a new figure with specified size
f3 = Figure(size = (1100, 1100))

# Define grid layouts for different sections of the figure
f3_title = f3[1, 0:3] = GridLayout()
f3_b11 = f3[2, 1] = GridLayout()
f3_b12 = f3[3, 1] = GridLayout()
f3_b13 = f3[4, 1] = GridLayout()
f3_b22 = f3[3, 2] = GridLayout()
f3_b23 = f3[4, 2] = GridLayout()
f3_b31 = f3[4, 3] = GridLayout()
f3_b24 = f3[2:4,0] = GridLayout()

# Define joint limits for the color scale of heatmaps
f3_joint_limits = (0.4, 1)

# Define axes for different sections of the figure
f3_AxisB11 = Axis(f3_b11[1,1], xlabel = "Zero-point instability \n σ of Normal (-3, σ) → cₚ",  ylabel = "Number of categories")
f3_AxisB12 = Axis(f3_b12[1,1], xlabel = "Scaling instability \n σ of Normal (6, σ) → xₚ", ylabel = "Number of categories")
f3_AxisB13 = Axis(f3_b13[1,1], xlabel = "Threshold instability \n σ of Normal (0, σ) → Kₚₜ", ylabel = "Number of categories")

f3_AxisB22 = Axis(f3_b22[1,1], xlabel = "Scaling instability \n σ of Normal (6, σ) → xₚ", ylabel = "Zero-point instability \n σ of Normal (-3, σ) → cₚ")
f3_AxisB23 = Axis(f3_b23[1,1], xlabel = "Threshold instability \n σ of Normal (0, σ) → α, β", ylabel = "Zero-point instability \n σ of Normal (-3, σ) → cₚ")
f3_AxisB31 = Axis(f3_b31[1,1], xlabel = "Threshold instability \n σ of Normal (0, σ) → α, β", ylabel = "Scaling instability \n σ of Normal (6, σ) → xₚ")

# Set title for the figure
Label(f3_title[1,1], "Experiment 1: \n Effect of Interactions Between Mapping Instability Parameters on Empirical Power", fontsize = 20, font = :bold, halign = :left)

# Generate heatmaps for different sections of the figure
f3_hmb11 = heatmap!(f3_AxisB11, intervalAndLbr.lbr_σ, intervalAndLbr.nIntervals, intervalAndLbr.Power, colorrange = f3_joint_limits, colorscale = scale, colormap = :roma)
f3_hmb12 = heatmap!(f3_AxisB12, intervalAndRbr.rbr_σ, intervalAndRbr.nIntervals, intervalAndRbr.Power, colorrange = f3_joint_limits, colorscale = scale, colormap = :roma)
f3_hmb13 = heatmap!(f3_AxisB13, intervalAndThα.th_σ, intervalAndThα.nIntervals, intervalAndThα.Power, colorrange = f3_joint_limits, colorscale = scale, colormap = :roma)

f3_hmb21 = heatmap!(f3_AxisB22, lbrAndRbr.rbr_σ, lbrAndRbr.lbr_σ, lbrAndRbr.Power, colorrange = f3_joint_limits, colorscale = scale, colormap = :roma)
f3_hmb22 = heatmap!(f3_AxisB23, lbrAndThα.th_σ, lbrAndThα.lbr_σ, lbrAndThα.Power, colorrange = f3_joint_limits, colorscale = scale, colormap = :roma)
f3_hmb31 = heatmap!(f3_AxisB31, rbrAndThα.th_σ, rbrAndThα.rbr_σ, rbrAndThα.Power, colorrange = f3_joint_limits, colorscale = scale, colormap = :roma)

# Add colorbar to the figure
f3_AxisB33 = Colorbar(f3_b24[1,1], f3_hmb11)

# Display the figure
f3
end

# ╔═╡ ceaa91fc-de1d-4287-9c6c-acf87171ed66
md"""
## Group-Based Mapping Instability Effects Type-I/Power

This plot shows different sub-types of the effect of group-based mapping instability on empirical power and Type I error rates. With group-based mapping instability, the mapping is different between groups, but does not randomly vary between observatons. The plot includes visualizations for zero-point instability, scaling instability, and systematic threshold instability, comparing a type of mapping instability with the value of a default without mapping instability.
"""

# ╔═╡ 8223f116-693c-4ca4-b0c0-1a0e1321d88c
begin
	f5 = Figure(size = (1600, 1600))

	# Set up the grid layout
	f5_title = f5[1, 1:3] = GridLayout()

	f5_illustrationheader = f5[2, 1] = GridLayout()
	f5_powerheader = f5[2, 2] = GridLayout()
	f5_errorheader = f5[2, 3] = GridLayout()

	f5_subtitle2 = f5[3, 1:3] = GridLayout()
	
	f5_l2 = f5[4, 1] = GridLayout()
	f5_m2 = f5[4, 2] = GridLayout()
	f5_r2 = f5[4, 3] = GridLayout()

	f5_subtitle3 = f5[5, 1:3] = GridLayout()

	f5_l3 = f5[6, 1] = GridLayout()
	f5_m3 = f5[6, 2] = GridLayout()
	f5_r3 = f5[6, 3] = GridLayout()

	f5_subtitle4 = f5[7, 1:3] = GridLayout()
	
	f5_l4 = f5[8, 1] = GridLayout()
	f5_m4 = f5[8, 2] = GridLayout()
	f5_r4 = f5[8, 3] = GridLayout()

	# Add explanatory diagrams to the plot.
	f5_img1 = rotr90(load("../Diagrams/zeropointinstability_groupbased.png"))
	f5_img2 = rotr90(load("../Diagrams/scalinginstability_groupbased.png"))
	f5_img3 = rotr90(load("../Diagrams/thresholdinstability_groupbased.png"))

	f5_AxisM2 = Axis(f5_l2[1,1], aspect = DataAspect())
	f5_AxisM3 = Axis(f5_l3[1,1], aspect = DataAspect())
	f5_AxisM4 = Axis(f5_l4[1,1], aspect = DataAspect())

	# Add axes to the plot
	f5_AxisL2 = Axis(f5_m2[1,1], xlabel = "Zero-point Instability \n Group 1: cₚ = -3.0 | Group 2: cₚ = 𝑥", ylabel = "Empirical Power (α ⩵ 0.05)", ylabelsize = 20, xlabelsize = 20)
	f5_AxisL3 = Axis(f5_m3[1,1], xlabel = "Scaling Instability \n Group 1: xₚ = 6.0 | Group 2: xₚ = 𝑥", ylabel = "Empirical Power (α ⩵ 0.05)", xlabelsize = 20, ylabelsize = 20)
	f5_AxisL4 = Axis(f5_m4[1,1], xlabel = "Threshold Instability \n Group 1: α & β = 0 | Group 2: α & β → 𝑥", ylabel = "Empirical power (α ⩵ 0.05)", xlabelsize = 20, ylabelsize = 20)

	image!(f5_AxisM2, f5_img1)
	image!(f5_AxisM3, f5_img2)
	image!(f5_AxisM4, f5_img3)

	f5_AxisR2 = Axis(f5_r2[1,1], xlabel = "Zero-point Instability \n Group 1: cₚ = 6.0 | Group 2: cₚ = 𝑥", ylabel = "Empirical Type I error rate (α ⩵ 0.05)", ylabelsize = 20, xlabelsize = 20)
	f5_AxisR3 = Axis(f5_r3[1,1], xlabel = "Scaling Instability \n Group 1: xₚ = -3.0 | Group 2: xₚ = 𝑥", ylabel = "Empirical Type I error rate (α ⩵ 0.05)", ylabelsize = 20, xlabelsize = 20)
	f5_AxisR4 = Axis(f5_r4[1,1], xlabel = "Threshold Instability \n Group 1: α & β = 0 | Group 2: α & β → 𝑥", ylabel = "Empirical Type I error rate (α ⩵ 0.05)", ylabelsize = 20, xlabelsize = 20)

	Label(f5_title[1,1], "Experiment 2: \n Effect of Group-Level Mapping Instability on Empirical Power and Type I Error", fontsize = 30, font = :bold, halign = :center)
	Label(f5_illustrationheader[1,1], fontsize = 20, "Type of Parameter", font = :bold_italic)
	Label(f5_powerheader[1,1], fontsize = 20, "Empirical Power", font = :bold_italic)
	Label(f5_errorheader[1,1], fontsize = 20, "Type I Error Rate", font = :bold_italic)

	Label(f5_subtitle2[1,1], "Zero-Point Instability", fontsize = 24, font = :bold, halign = :left)
	Label(f5_subtitle3[1,1], "Scaling Instability", fontsize = 24, font = :bold, halign = :left)
	Label(f5_subtitle4[1,1], "Threshold Instability", fontsize = 24, font = :bold, halign = :left)

	linkxaxes!(f5_AxisL2, f5_AxisR2)
	linkxaxes!(f5_AxisL3, f5_AxisR3)
	linkxaxes!(f5_AxisL4, f5_AxisR4)

	linkyaxes!(f5_AxisL2, f5_AxisL3, f5_AxisL4, f5_AxisR2, f5_AxisR3, f5_AxisR4)

	# Add results from the unmapped (untransformed) data
	hlines!(f5_AxisL2, 0.832, color = :cyan3, label = "Power for stable mapping")
	hlines!(f5_AxisR2, 0.05, color = :cyan3, label = "Type I for stable mapping")
	hlines!(f5_AxisL3, 0.832, color = :cyan3)
	hlines!(f5_AxisR3, 0.05, color = :cyan3)
	hlines!(f5_AxisL4, 0.832, color = :cyan3)
	hlines!(f5_AxisR4, 0.05, color = :cyan3)

	# Add results from the transformed data.
	scatterlines!(f5_AxisL2, onlyRbr_gb.rbr_σ, onlyRbr_gb.Power, color = :blue, label = "Power for unstable mapping")
	errorbars!(f5_AxisL2,onlyRbr_gb.rbr_σ, onlyRbr_gb.Power, 1.96*onlyRbr_gb.Power_SDE, whiskerwidth = 8, color = :red)
	
	scatterlines!(f5_AxisR2, onlyRbr_gb.rbr_σ, onlyRbr_gb.TypeI, color = :blue, label = "Type I for unstable mapping")
	errorbars!(f5_AxisR2, onlyRbr_gb.rbr_σ, onlyRbr_gb.TypeI, 1.96*onlyRbr_gb.TypeI_SDE, whiskerwidth = 8, color = :red)

	scatterlines!(f5_AxisL3, onlyLbr_gb.lbr_σ, onlyLbr_gb.Power, color = :blue)
	errorbars!(f5_AxisL3, onlyLbr_gb.lbr_σ, onlyLbr_gb.Power, 1.96*onlyLbr_gb.Power_SDE, whiskerwidth = 8, color = :red)
	
	scatterlines!(f5_AxisR3, onlyLbr_gb.lbr_σ, onlyLbr_gb.TypeI, color = :blue)
	errorbars!(f5_AxisR3, onlyLbr_gb.lbr_σ, onlyLbr_gb.TypeI, 1.96*onlyLbr_gb.TypeI_SDE, whiskerwidth = 8, color = :red)
	
	scatterlines!(f5_AxisL4, onlyα_gb.th_α, onlyα_gb.Power, color = :blue)
	errorbars!(f5_AxisL4, onlyα_gb.th_α, onlyα_gb.Power, 1.96*onlyα_gb.Power_SDE, whiskerwidth = 8, color = :red)
	
	scatterlines!(f5_AxisR4, onlyα_gb.th_α, onlyα_gb.TypeI, color = :blue)
	errorbars!(f5_AxisR4, onlyα_gb.th_α, onlyα_gb.TypeI, 1.96*onlyα_gb.TypeI_SDE, whiskerwidth = 8, color = :red)
	
	hidedecorations!(f5_AxisM2)
	hidespines!(f5_AxisM2)

	colsize!(f5.layout, 1, Relative(1/3))
	colsize!(f5.layout, 2, Relative(1/3))
	colsize!(f5.layout, 3, Relative(1/3))

	f5_legendheader1 = Legend(f5[9, 2], f5_AxisR2, aspect = :nothing, tellheight = true, labelsize = 20)
	f5_legendheader2 = Legend(f5[9, 3], f5_AxisL2, aspect = :nothing, tellheight = true, labelsize = 20)

	hidedecorations!(f5_AxisM3)
	hidespines!(f5_AxisM3)

	hidedecorations!(f5_AxisM4)
	hidespines!(f5_AxisM4)
	
	f5
end

# ╔═╡ 2e11f585-2281-42f2-b0b4-e4a1a92ca69c
md"""
## Two-Way Interactions Group-Based Mapping Instability Parameters Power

This code generates a series of heatmaps arranged in a grid layout, representing the interactions between different parameters of group-based mapping instability and their effects on empirical power in Experiment 1. The heatmaps visualize how variations in parameters  zero-point instability, scaling instability, and threshold instability impacts the empirical power of a simple t-test.
"""

# ╔═╡ bed8540d-3095-4a8f-b5e1-45035f2df16c
begin
    # Create a figure with specified size
    f6 = Figure(size = (1100, 1100))
    
    # Set up the grid layout for different sections of the plot
    f6_title = f6[1, 0:3] = GridLayout()
    f6_b11 = f6[2, 1] = GridLayout()
    f6_b12 = f6[3, 1] = GridLayout()
    f6_b13 = f6[4, 1] = GridLayout()
    f6_b22 = f6[3, 2] = GridLayout()
    f6_b23 = f6[4, 2] = GridLayout()
    f6_b31 = f6[4, 3] = GridLayout()
    f6_b24 = f6[2:4,0] = GridLayout()

    # Set limits for the color scale
    f6_joint_limits = (0.6, 1)

    # Define a scale for the heatmap color scale
    f6_scale = ReversibleScale(x -> asinh(x / 2) / log(10), x -> 2sinh(log(10) * x))

    # Set up axes for the heatmaps
    f6_AxisB11 = Axis(f6_b11[1,1], xlabel = "Zero-point Instability \n Group 1: cₚ = 6.0 | Group 2: cₚ = 𝑥",  ylabel = "Number of categories")
    f6_AxisB12 = Axis(f6_b12[1,1], xlabel = "Scaling Instability \n Group 1: xₚ = 6.0 | Group 2: xₚ = 𝑥", ylabel = "Number of categories")
    f6_AxisB13 = Axis(f6_b13[1,1], xlabel = "Threshold Instability \n Group 1: α & β = 0 | Group 2: α & β → 𝑥", ylabel = "Number of categories")
    f6_AxisB22 = Axis(f6_b22[1,1], xlabel = "Scaling Instability \n Group 1: xₚ = 6.0 | Group 2: xₚ = 𝑥", ylabel = "Zero-point Instability \n Group 1: cₚ = 6.0 | Group 2: cₚ = 𝑦")
    f6_AxisB23 = Axis(f6_b23[1,1], xlabel = "Threshold Instability \n Group 1: α & β = 0 | Group 2: α & β → 𝑥", ylabel = "Zero-point Instability \n Group 1: cₚ = 6.0 | Group 2: cₚ = 𝑦")
    f6_AxisB31 = Axis(f6_b31[1,1], xlabel = "Threshold Instability \n Group 1: α & β = 0 | Group 2: α & β → 𝑥", ylabel = "Scaling Instability \n Group 1: xₚ = 6.0 | Group 2: xₚ = 𝑦")

    # Set the title for the plot
    Label(f6_title[1,1], "Experiment 2: \n Effect of Interactions Between Mapping Instability Parameters on Empirical Power", fontsize = 20, font = :bold, halign = :left)
    
    # Plot the heatmaps for different combinations of instability parameters
    f6_hmb11 = heatmap!(f6_AxisB11, intervalAndLbr_gb.lbr_σ, intervalAndLbr_gb.nIntervals, intervalAndLbr_gb.Power, colorrange = f6_joint_limits, colorscale = scale, colormap = :roma)
    f6_hmb12 = heatmap!(f6_AxisB12, intervalAndRbr.rbr_σ, intervalAndRbr.nIntervals, intervalAndRbr.Power, colorrange = f6_joint_limits, colorscale = scale, colormap = :roma)
    f6_hmb13 = heatmap!(f6_AxisB13, intervalAndThα_gb.th_α, intervalAndThα_gb.nIntervals, intervalAndThα_gb.Power, colorrange = f6_joint_limits, colorscale = scale, colormap = :roma)
    f6_hmb21 = heatmap!(f6_AxisB22, lbrAndRbr_gb.rbr_σ, lbrAndRbr_gb.lbr_σ, lbrAndRbr_gb.Power, colorrange = f6_joint_limits, colorscale = scale, colormap = :roma)
    f6_hmb22 = heatmap!(f6_AxisB23, lbrAndThα_gb.th_α, lbrAndThα_gb.lbr_σ, lbrAndThα_gb.Power, colorrange = f6_joint_limits, colorscale = scale, colormap = :roma)
    f6_hmb31 = heatmap!(f6_AxisB31, rbrAndThα_gb.th_α, rbrAndThα_gb.rbr_σ, rbrAndThα_gb.Power, colorrange = f6_joint_limits, colorscale = scale, colormap = :roma)

    # Add a colorbar to the plot
    f6_AxisB33 = Colorbar(f6_b24[1,1], f6_hmb11)

    # Return the figure
    f6
end 

# ╔═╡ 1c182c04-7e54-4baa-81d5-92d323dd918d
md"""
## Two-Way Interactions Group-Based Mapping Instability Parameters Type-I

This code generates a series of heatmaps arranged in a grid layout, representing the interactions between different parameters of group-based mapping instability and their effects on Type-I error for Experiment 2. The heatmaps visualize how variations in parameters zero-point instability, scaling instability, and threshold instability impacts the Type-I error of a simple t-test.
"""

# ╔═╡ 53e58f32-c3da-487a-8fff-38bcb64a8203
begin
	# Define a figure with a specified size
	f7 = Figure(size = (1100, 1100))

	# Set up the grid layout for different sections of the plot
	f7_title3 = f7[1, 0:3] = GridLayout()
	f7_b11 = f7[2, 1] = GridLayout()
	f7_b12 = f7[3, 1] = GridLayout()
	f7_b13 = f7[4, 1] = GridLayout()
	f7_b22 = f7[3, 2] = GridLayout()
	f7_b23 = f7[4, 2] = GridLayout()
	f7_b31 = f7[4, 3] = GridLayout()
	f7_b24 = f7[2:4,0] = GridLayout()

	# Define joint limits for color scale
	f7_joint_limits = (0, 0.8)

	# Define a scale for the heatmap color scale
	f7_scale = ReversibleScale(x -> asinh(x / 2) / log(10), x -> 2sinh(log(10) * x))

	# Set up axes for the heatmaps
	f7_AxisB11 = Axis(f7_b11[1,1], xlabel = "Zero-point Instability \n Group 1: cₚ = 6.0 | Group 2: cₚ = 𝑥",  ylabel = "Number of categories")
	f7_AxisB12 = Axis(f7_b12[1,1], xlabel = "Scaling Instability \n Group 1: xₚ = 6.0 | Group 2: xₚ = 𝑥", ylabel = "Number of categories")
	f7_AxisB13 = Axis(f7_b13[1,1], xlabel = "Threshold Instability \n Group 1: α & β = 0 | Group 2: α & β → 𝑥", ylabel = "Number of categories")
	f7_AxisB22 = Axis(f7_b22[1,1], xlabel = "Scaling Instability \n Group 1: xₚ = 6.0 | Group 2: xₚ = 𝑥", ylabel = "Zero-point Instability \n Group 1: cₚ = -3.0 | Group 2: cₚ = 𝑦")
	f7_AxisB23 = Axis(f7_b23[1,1], xlabel = "Threshold Instability \n Group 1: α & β = 0 | Group 2: α & β → 𝑥", ylabel = "Zero-point Instability \n Group 1: cₚ = 6.0 | Group 2: cₚ = 𝑦")
	f7_AxisB31 = Axis(f7_b31[1,1], xlabel = "Threshold Instability \n Group 1: α & β = 0 | Group 2: α & β → 𝑥", ylabel = "Scaling Instability \n Group 1: xₚ = 6.0 | Group 2: xₚ = 𝑦")

	# Set up title for the plot
	Label(f7_title3[1,1], "Experiment 2: \n Effect of Interactions Between Mapping Instability Parameters on Empirical Type-I Error", fontsize = 20, font = :bold, halign = :left)

	# Plot the heatmaps for different combinations of instability parameters
	f7_hmb11 = heatmap!(f7_AxisB11, intervalAndLbr_gb.lbr_σ, intervalAndLbr_gb.nIntervals, intervalAndLbr_gb.TypeI, colorrange = f7_joint_limits, colorscale = scale, colormap = Reverse(:roma))
	f7_hmb12 = heatmap!(f7_AxisB12, intervalAndRbr_gb.rbr_σ, intervalAndRbr_gb.nIntervals, intervalAndRbr_gb.TypeI, colorrange = f7_joint_limits, colorscale = scale, colormap = Reverse(:roma))
	f7_hmb13 = heatmap!(f7_AxisB13, intervalAndThα_gb.th_α, intervalAndThα_gb.nIntervals, intervalAndThα_gb.TypeI, colorrange = f7_joint_limits, colorscale = scale, colormap = Reverse(:roma))
	f7_hmb21 = heatmap!(f7_AxisB22, lbrAndRbr_gb.rbr_σ, lbrAndRbr_gb.lbr_σ, lbrAndRbr_gb.TypeI, colorrange = f7_joint_limits, colorscale = scale, colormap = Reverse(:roma))
	f7_hmb22 = heatmap!(f7_AxisB23, lbrAndThα_gb.th_α, lbrAndThα_gb.lbr_σ, 	lbrAndThα_gb.TypeI, colorrange = f7_joint_limits, colorscale = scale, colormap = Reverse(:roma))
	f7_hmb31 = heatmap!(f7_AxisB31, rbrAndThα_gb.th_α, rbrAndThα_gb.rbr_σ, rbrAndThα_gb.TypeI, colorrange = f7_joint_limits, colorscale = scale, colormap = Reverse(:roma))

	# Add a colorbar to the plot
	f7_AxisB33 = Colorbar(f7_b24[1,1], f7_hmb11)

	# Return the figure
	f7
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
Pipe = "b98c9c47-44ae-5843-9183-064241ee97a0"

[compat]
CSV = "~0.10.13"
CairoMakie = "~0.11.9"
DataFrames = "~1.6.1"
FileIO = "~1.16.3"
Pipe = "~1.3.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "648428b45c832c4f380bb0df53e0a6a81dae5e77"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractLattices]]
git-tree-sha1 = "222ee9e50b98f51b5d78feb93dd928880df35f06"
uuid = "398f06c4-4d28-53ec-89ca-5b2656b7603d"
version = "0.3.0"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.Animations]]
deps = ["Colors"]
git-tree-sha1 = "e81c509d2c8e49592413bfb0bb3b08150056c79d"
uuid = "27a7e980-b3e6-11e9-2bcd-0b925532e340"
version = "0.4.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "44691067188f6bd1b2289552a23e4b7572f4528d"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.9.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Automa]]
deps = ["PrecompileTools", "TranscodingStreams"]
git-tree-sha1 = "588e0d680ad1d7201d4c6a804dcb1cd9cba79fbb"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "1.0.3"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CRC32c]]
uuid = "8bf52ea8-c179-5cab-976a-9e18b702a9bc"

[[deps.CRlibm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e329286945d0cfc04456972ea732551869af1cfc"
uuid = "4e9b3aee-d8a1-5a3d-ad8b-7d824db253f0"
version = "1.0.1+0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "a44910ceb69b0d44fe262dd451ab11ead3ed0be8"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.13"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.CairoMakie]]
deps = ["CRC32c", "Cairo", "Colors", "FFTW", "FileIO", "FreeType", "GeometryBasics", "LinearAlgebra", "Makie", "PrecompileTools"]
git-tree-sha1 = "6dc1bbdd6a133adf4aa751d12dbc2c6ae59f873d"
uuid = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0"
version = "0.11.9"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a4c43f59baa34011e303e76f5c8c91bf58415aaf"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "575cd02e080939a33b6df6c5853d14924c08e35b"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.23.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[deps.ColorBrewer]]
deps = ["Colors", "JSON", "Test"]
git-tree-sha1 = "61c5334f33d91e570e1d0c3eb5465835242582c4"
uuid = "a2cac450-b92f-5266-8821-25eda20663c8"
version = "0.4.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "c955881e3c981181362ae4088b35995446298b80"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.14.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "260fd2400ed2dab602a7c15cf10c1933c59930a2"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.5"
weakdeps = ["IntervalSets", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "0f4b5d62a88d8f59003e43c25a8a90de9eb76317"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.18"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelaunayTriangulation]]
deps = ["DataStructures", "EnumX", "ExactPredicates", "Random", "SimpleGraphs"]
git-tree-sha1 = "d4e9dc4c6106b8d44e40cd4faf8261a678552c7c"
uuid = "927a84f5-c5f4-47a5-9785-b46e178433df"
version = "0.8.12"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "7c302d7a5fec5214eb8a5a4c466dcf7a51fcf169"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.107"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.ExactPredicates]]
deps = ["IntervalArithmetic", "Random", "StaticArrays"]
git-tree-sha1 = "b3f2ff58735b5f024c392fde763f29b057e4b025"
uuid = "429591f6-91af-11e9-00e2-59fbe8cec110"
version = "2.2.8"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.Extents]]
git-tree-sha1 = "2140cd04483da90b2da7f99b2add0750504fc39c"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.2"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "ab3f7e1819dba9434a3a5126510c8fda3a4e7000"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "6.1.1+0"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "4820348781ae578893311153d69049a93d05f39d"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.8.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FilePaths]]
deps = ["FilePathsBase", "MacroTools", "Reexport", "Requires"]
git-tree-sha1 = "919d9412dbf53a2e6fe74af62a73ceed0bce0629"
uuid = "8fc22ac5-c921-52a6-82fd-178b2807b824"
version = "0.8.3"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "5b93957f6dcd33fc343044af3d48c215be2562f1"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.9.3"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays"]
git-tree-sha1 = "bc0c5092d6caaea112d3c8e3b238d61563c58d5f"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.23.0"

    [deps.FiniteDiff.extensions]
    FiniteDiffBandedMatricesExt = "BandedMatrices"
    FiniteDiffBlockBandedMatricesExt = "BlockBandedMatrices"
    FiniteDiffStaticArraysExt = "StaticArrays"

    [deps.FiniteDiff.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType]]
deps = ["CEnum", "FreeType2_jll"]
git-tree-sha1 = "907369da0f8e80728ab49c1c7e09327bf0d6d999"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.1.1"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FreeTypeAbstraction]]
deps = ["ColorVectorSpace", "Colors", "FreeType", "GeometryBasics"]
git-tree-sha1 = "055626e1a35f6771fe99060e835b72ca61a52621"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.10.1"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "d4f85701f569584f2cff7ba67a137d03f0cfb7d0"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.3.3"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "Extents", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "5694b56ccf9d15addedc35e9a4ba9c317721b788"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.10"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "359a1ba2e320790ddbe4ee8b4d54a305c0ea2aff"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.0+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.GridLayoutBase]]
deps = ["GeometryBasics", "InteractiveUtils", "Observables"]
git-tree-sha1 = "6f93a83ca11346771a93bbde2bdad2f65b61498f"
uuid = "3955a311-db13-416c-9275-1d80ed98e5e9"
version = "0.10.2"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "eb49b82c172811fd2c86759fa0553a2221feb909"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.7"

[[deps.ImageCore]]
deps = ["ColorVectorSpace", "Colors", "FixedPointNumbers", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "PrecompileTools", "Reexport"]
git-tree-sha1 = "b2a7eaa169c13f5bcae8131a83bc30eff8f71be0"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.10.2"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "bca20b2f5d00c4fbc192c3212da8fa79f4688009"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.7"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3d09a9f60edf77f8a4d99f9e015e8fbf9989605d"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.7+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "ea8031dea4aff6bd41f1df8f2fdfb25b33626381"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.4"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "b8ffb903da9f7b8cf695a8bead8e01814aa24b30"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.2"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "5fdf2fe6724d8caabf43b557b84ce53f3b7e2f6b"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.0.2+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "88a101217d7cb38a7b481ccd50d21876e1d1b0e0"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.15.1"

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

    [deps.Interpolations.weakdeps]
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.IntervalArithmetic]]
deps = ["CRlibm_jll", "RoundingEmulator"]
git-tree-sha1 = "552505ed27d2a90ff04c15b0ecf4634e0ab5547b"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.22.9"
weakdeps = ["DiffRules", "ForwardDiff", "RecipesBase"]

    [deps.IntervalArithmetic.extensions]
    IntervalArithmeticDiffRulesExt = "DiffRules"
    IntervalArithmeticForwardDiffExt = "ForwardDiff"
    IntervalArithmeticRecipesBaseExt = "RecipesBase"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.Isoband]]
deps = ["isoband_jll"]
git-tree-sha1 = "f9b6d97355599074dc867318950adaa6f9946137"
uuid = "f1662d9f-8043-43de-a69a-05efc1cc6ff4"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "fa6d0bcff8583bac20f1ffa708c3913ca605c611"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.5"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3336abae9a713d2210bb57ab484b1e065edd7d23"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.2+0"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "fee018a29b60733876eb557804b5b109dd3dd8a7"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.8"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "dae976433497a2f841baadea93d27e68f1a12a97"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.39.3+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0a04a1318df1bf510beb2562cf90fb0c386f58c4"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.39.3+1"

[[deps.LightXML]]
deps = ["Libdl", "XML2_jll"]
git-tree-sha1 = "3a994404d3f6709610701c7dabfc03fed87a81f8"
uuid = "9c8b4983-aa76-5018-a973-4c85ecc9e179"
version = "0.9.1"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearAlgebraX]]
deps = ["LinearAlgebra", "Mods", "Primes", "SimplePolynomials"]
git-tree-sha1 = "d76cec8007ec123c2b681269d40f94b053473fcf"
uuid = "9b3f67b0-2d00-526e-9884-9e4938f8fb88"
version = "0.2.7"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "18144f3e9cbe9b15b070288eef858f71b291ce37"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.27"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "72dc3cf284559eb8f53aa593fe62cb33f83ed0c0"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.0.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Makie]]
deps = ["Animations", "Base64", "CRC32c", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "Contour", "DelaunayTriangulation", "Distributions", "DocStringExtensions", "Downloads", "FFMPEG_jll", "FileIO", "FilePaths", "FixedPointNumbers", "Format", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageIO", "InteractiveUtils", "IntervalSets", "Isoband", "KernelDensity", "LaTeXStrings", "LinearAlgebra", "MacroTools", "MakieCore", "Markdown", "MathTeXEngine", "Observables", "OffsetArrays", "Packing", "PlotUtils", "PolygonOps", "PrecompileTools", "Printf", "REPL", "Random", "RelocatableFolders", "Scratch", "ShaderAbstractions", "Showoff", "SignedDistanceFields", "SparseArrays", "StableHashTraits", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "TriplotBase", "UnicodeFun"]
git-tree-sha1 = "27af6be179c711fb916a597b6644fbb5b80becc0"
uuid = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
version = "0.20.8"

[[deps.MakieCore]]
deps = ["Observables", "REPL"]
git-tree-sha1 = "248b7a4be0f92b497f7a331aed02c1e9a878f46b"
uuid = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
version = "0.7.3"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MathTeXEngine]]
deps = ["AbstractTrees", "Automa", "DataStructures", "FreeTypeAbstraction", "GeometryBasics", "LaTeXStrings", "REPL", "RelocatableFolders", "UnicodeFun"]
git-tree-sha1 = "96ca8a313eb6437db5ffe946c457a401bbb8ce1d"
uuid = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"
version = "0.5.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Mods]]
git-tree-sha1 = "924f962b524a71eef7a21dae1e6853817f9b658f"
uuid = "7475f97c-0381-53b1-977b-4c60186c8d62"
version = "2.2.4"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.Multisets]]
git-tree-sha1 = "8d852646862c96e226367ad10c8af56099b4047e"
uuid = "3b2b4ff1-bcff-5658-a3ee-dbcf1ce5ac09"
version = "0.4.4"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "7438a59546cf62428fc9d1bc94729146d37a7225"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.5"

[[deps.OffsetArrays]]
git-tree-sha1 = "6a731f2b5c03157418a20c12195eb4b74c8f8621"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.13.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "a4ca623df1ae99d09bc9868b008262d0c0ac1e4f"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.4+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "60e3045590bd104a16fefb12836c00c0ef8c7f8c"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "PackageExtensionCompat", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "d1223e69af90b6d26cea5b6f3b289b3148ba702c"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.9.3"

    [deps.Optim.extensions]
    OptimMOIExt = "MathOptInterface"

    [deps.Optim.weakdeps]
    MathOptInterface = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "67186a2bc9a90f9f85ff3cc8277868961fb57cbd"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.3"

[[deps.PackageExtensionCompat]]
git-tree-sha1 = "fb28e33b8a95c4cee25ce296c817d89cc2e53518"
uuid = "65ce6f38-6b18-4e1d-a461-8949797d7930"
version = "1.0.2"
weakdeps = ["Requires", "TOML"]

[[deps.Packing]]
deps = ["GeometryBasics"]
git-tree-sha1 = "ec3edfe723df33528e085e632414499f26650501"
uuid = "19eb6ba3-879d-56ad-ad62-d5c202156566"
version = "0.5.0"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "526f5a03792669e4187e584e8ec9d534248ca765"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.52.1+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Permutations]]
deps = ["Combinatorics", "LinearAlgebra", "Random"]
git-tree-sha1 = "eb3f9df2457819bf0a9019bd93cc451697a0751e"
uuid = "2ae35dd2-176d-5d53-8349-f30d82d94d4f"
version = "0.4.20"

[[deps.PikaParser]]
deps = ["DocStringExtensions"]
git-tree-sha1 = "d6ff87de27ff3082131f31a714d25ab6d0a88abf"
uuid = "3bbf5609-3e7b-44cd-8549-7c69f321e792"
version = "0.6.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "7b1a9df27f072ac4c9c7cbe5efb198489258d1f5"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.1"

[[deps.PolygonOps]]
git-tree-sha1 = "77b3d3605fc1cd0b42d95eba87dfcd2bf67d5ff6"
uuid = "647866c9-e3ac-4575-94e7-e3d426903924"
version = "0.1.2"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase", "Setfield", "SparseArrays"]
git-tree-sha1 = "a9c7a523d5ed375be3983db190f6a5874ae9286d"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "4.0.6"

    [deps.Polynomials.extensions]
    PolynomialsChainRulesCoreExt = "ChainRulesCore"
    PolynomialsFFTWExt = "FFTW"
    PolynomialsMakieCoreExt = "MakieCore"
    PolynomialsMutableArithmeticsExt = "MutableArithmetics"

    [deps.Polynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    FFTW = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
    MakieCore = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
    MutableArithmetics = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "cb420f77dc474d23ee47ca8d14c90810cafe69e7"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.6"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "763a8ceb07833dd51bb9e3bbca372de32c0605ad"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9b23c31e76e333e6fb4c1595ae6afa74966a729e"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.RingLists]]
deps = ["Random"]
git-tree-sha1 = "f39da63aa6d2d88e0c1bd20ed6a3ff9ea7171ada"
uuid = "286e9d63-9694-5540-9e3c-4e6708fa07b2"
version = "0.2.8"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.RoundingEmulator]]
git-tree-sha1 = "40b9edad2e5287e05bd413a38f61a8ff55b9557b"
uuid = "5eaf0fd0-dfba-4ccb-bf02-d820a40db705"
version = "0.2.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "0e7508ff27ba32f26cd459474ca2ede1bc10991f"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.ShaderAbstractions]]
deps = ["ColorTypes", "FixedPointNumbers", "GeometryBasics", "LinearAlgebra", "Observables", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "79123bc60c5507f035e6d1d9e563bb2971954ec8"
uuid = "65257c39-d410-5151-9873-9b3e5be5013e"
version = "0.4.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SignedDistanceFields]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "d263a08ec505853a5ff1c1ebde2070419e3f28e9"
uuid = "73760f76-fbc4-59ce-8f25-708e95d2df96"
version = "0.4.0"

[[deps.SimpleGraphs]]
deps = ["AbstractLattices", "Combinatorics", "DataStructures", "IterTools", "LightXML", "LinearAlgebra", "LinearAlgebraX", "Optim", "Primes", "Random", "RingLists", "SimplePartitions", "SimplePolynomials", "SimpleRandom", "SparseArrays", "Statistics"]
git-tree-sha1 = "f65caa24a622f985cc341de81d3f9744435d0d0f"
uuid = "55797a34-41de-5266-9ec1-32ac4eb504d3"
version = "0.8.6"

[[deps.SimplePartitions]]
deps = ["AbstractLattices", "DataStructures", "Permutations"]
git-tree-sha1 = "e182b9e5afb194142d4668536345a365ea19363a"
uuid = "ec83eff0-a5b5-5643-ae32-5cbf6eedec9d"
version = "0.3.2"

[[deps.SimplePolynomials]]
deps = ["Mods", "Multisets", "Polynomials", "Primes"]
git-tree-sha1 = "7063828369cafa93f3187b3d0159f05582011405"
uuid = "cc47b68c-3164-5771-a705-2bc0097375a0"
version = "0.2.17"

[[deps.SimpleRandom]]
deps = ["Distributions", "LinearAlgebra", "Random"]
git-tree-sha1 = "3a6fb395e37afab81aeea85bae48a4db5cd7244a"
uuid = "a6525b86-64cd-54fa-8f65-62fc48bdc0e8"
version = "0.3.1"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableHashTraits]]
deps = ["Compat", "PikaParser", "SHA", "Tables", "TupleTools"]
git-tree-sha1 = "10dc702932fe05a0e09b8e5955f00794ea1e8b12"
uuid = "c5dd0088-6c3f-4803-b00e-f31a60c170fa"
version = "1.1.8"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "bf074c045d3d5ffd956fa0a461da38a44685d6b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.3"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "cef0472124fab0695b58ca35a77c6fb942fdab8a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.1"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.StructArrays]]
deps = ["ConstructionBase", "DataAPI", "Tables"]
git-tree-sha1 = "f4dc295e983502292c4c3f951dbb4e985e35b3be"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.18"

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = "GPUArraysCore"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

    [deps.StructArrays.weakdeps]
    Adapt = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "34cc045dd0aaa59b8bbe86c644679bc57f1d5bd0"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.8"

[[deps.TranscodingStreams]]
git-tree-sha1 = "14389d51751169994b2e1317d5c72f7dc4f21045"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.6"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.TriplotBase]]
git-tree-sha1 = "4d4ed7f294cda19382ff7de4c137d24d16adc89b"
uuid = "981d1d27-644d-49a2-9326-4793e63143c3"
version = "0.1.0"

[[deps.TupleTools]]
git-tree-sha1 = "41d61b1c545b06279871ef1a4b5fcb2cac2191cd"
uuid = "9d95972d-f1c8-5527-a6e0-b4b365fa01f6"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "07e470dabc5a6a4254ffebc29a1b3fc01464e105"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.isoband_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51b5eeb3f98367157a7a12a1fb0aa5328946c03c"
uuid = "9a68df92-36a6-505f-a73e-abb412b6bfb4"
version = "0.2.3+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"
"""

# ╔═╡ Cell order:
# ╟─75ec7454-2760-4e2e-9016-509fce4b2ca1
# ╟─0f32e5ae-a6bf-453d-beef-530c6ba6c654
# ╠═33346680-f0d0-11ee-360d-7f79d033e3da
# ╟─8f916ee1-36ed-4d0b-af74-4a3eee70576b
# ╠═067cee09-2883-4013-b21c-7808102a4328
# ╠═25c9c157-c116-43d1-87dc-6e298537987f
# ╠═4df00c27-8a97-442f-84f5-11a342ed380c
# ╟─aff7cb92-72b8-4e79-9b51-f4b1e442951a
# ╠═0881b78e-ae10-4277-9bfb-26f7ac68512c
# ╠═cb50185d-9dc8-4201-a1a7-fc4392bc1dc7
# ╟─6ed60b8f-bb14-4fad-ba41-723b8700ad42
# ╠═1f986790-6f45-4ccb-a9fd-3449f895538f
# ╟─8bc963a4-25e9-4660-91ec-2f1f76866fa6
# ╠═4bab68ed-c529-4512-84f6-5bd17c3fa8d0
# ╟─6a0f9b1a-3474-4a1d-9038-18f44d90eea2
# ╠═d3f26221-8558-4e8c-a6da-ac6580ee3b58
# ╟─a2a3bf3d-33fb-4b7e-bc97-00b53bb3f902
# ╠═ca60ad2c-d9c5-420d-a271-825551b3a3dc
# ╟─ceaa91fc-de1d-4287-9c6c-acf87171ed66
# ╠═8223f116-693c-4ca4-b0c0-1a0e1321d88c
# ╟─2e11f585-2281-42f2-b0b4-e4a1a92ca69c
# ╠═bed8540d-3095-4a8f-b5e1-45035f2df16c
# ╟─1c182c04-7e54-4baa-81d5-92d323dd918d
# ╠═53e58f32-c3da-487a-8fff-38bcb64a8203
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
