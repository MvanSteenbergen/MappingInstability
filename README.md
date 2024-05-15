# Mapping Instability on Rating Scale Responses

This is the repository for the materials for the paper `Mapping Instability on Rating Scale Responses.' Two experiments are included, focusing on investigating the impact of mapping instability on statistical analyses. In the first experiment, random mapping instability was introduced across all observations to assess its effects on statistical power and Type I error rates. The second experiment aimed to evaluate the effects of group-based mapping instability, where mapping inconsistencies were introduced between two experimental conditions while maintaining stability within each group.

The data is generated as part of the simulation code. They cannot be divided due to the research set-up. Detailed instructions for running the experiment can be found under the header `research recipe' below.

All README information is found in this top-level document. All code files are annotated using the Pluto.jl notebook software.

# Version information

Julia 1.10.0 was used for the code. Detailed package information, included dependencies and version numbers are stored in the manifest.toml file at the bottom of each .jl file. These can be read by opening the .jl files in notepad.

All illustrative diagrams (not plots) were created using draw.io.

# License

All scripts are MIT Licensed. The license is added to the top of those files.

# Ethics, privacy, and security.

All software used in this project is open-source. No participants or privacy-sensitive content were involved in the production and running of the simulation study. The study was approved by the Ethical Review Board of the Faculty of Social and Behavioural Sciences of Utrecht University (23-1844).

## Permission and access

All material involved in the production of this thesis project is available on [GitHub](https://github.com/MvanSteenbergen/MappingInstability). Maas van Steenbergen is the maintainer of this repository. He can be contacted via mvansteenbergen@proton.me.

# Folder hierarchy

./Simulation - Contains the code that I used to run the simulation and  
Subdivided into:

- ./Code: Contains all the code used to run the simulation and plot the results. `./random_diff.jl` and `./group_diff.jl` contain experiment 1 and experiment 2, and `./analysis.jl` contains making the plots.
- ./Data: Contains the generated data.
- ./Diagrams: Diagrams used by `analysis.jl` to plot the effects of mapping instability.

./Plots - Contains all plots as they are used in the final paper.
./Thesis - Contains the latex source code for my thesis.

Earlier versions of the paper/presentations of my progress are also included:

./Legacy/Presentation 19-9-2023 - This contains a presentation that I gave for my thesis proposal
./Legacy/Presentation 13-12-2023 - This contains a half-way presentation for my thesis, be aware that my topic was (very!) different back then as well.
./Legacy/Proposal - This contains my thesis proposal file. Note that this paper is very different from what I ended up doing.
./Legacy/ResearchReport - Contains the pdf of the paper during a half-way. Note that this paper is very different from what I ended up doing.

## Research recipe

### Installing Julia

The code is in the folder "Code". If you haven't installed the julia language, install it first at [the Julia website](https://julialang.org/). Make sure the file hierarchy is maintained, so clone the entire repository!

### Install Pluto

First, you have to install Pluto and open the files. You don't have to install the packages separately, or do anything else. All the packages are contained in Pluto notebook files. These contain the version dependencies for the packages and they should be installed automatically. NOTE THAT THE VERSION INFORMATION IS SAVED IN THE DOCUMENT AS A MANIFEST.TOML ON THE BOTTOM OF THE .JL FILES. Open a Julia-terminal in the containing folder. Then, run the following commands in the command line interface:

    using Pkg
    Pkg.add("Pluto")
    using Pluto
    Pluto.run()

Now, Pluto will open. Browse to the file in the file picker at the bottom. Be sure to press Enter, as clicken open will remove the input (for me at least.).

### Open Pluto files

1. Browse to `./Simulation/Code/random_diff.jl` in the pluto user interface file picker. Press the Enter-button. This file contains all the code and the annotations for the first simulation study. Press `run notebook code' on the top right of the page. The simulation will now run. Note that it may take a while (for me it takes about 20 minutes - after heavy code optimization)

2. Browse to `./Simulation/Code/group_diff.jl` in the pluto user interface file picker. Press the Enter-button. This file contains all the code and the annotations for the second simulation study. Press `run notebook code' on the top right of the page. The simulation will now run. Note that it may take a while (for me it takes about 20 minutes - after heavy code optimization)

3. Browse to `./Simulation/Code/analysis.jl` in the pluto user file picker. Press the Enter-button. This file contains all the code and annotations for the plots and the analysis for the second simulation study. ALL PLOTS ARE SAVED WITHIN THE NOTEBOOK FILE, AND CAN BE SAVED TO YOUR COMPUTER BY RIGHT-CLICKING AND CLICKING DOWNLOAD.

@Em.Aa. If you want to test reproducability, delete the Data folder and run the first two files. This is the only output not saved internally in the pluto notebooks. If you want to test reproducability of the plots, just run the notebook file. It should result in equivalent plots to the plots in my paper. The data is read and displayed at the top of the analysis.jl file.

# Compiling the latex file

You can compile the latex file using texworks:

1. **Download TeXworks**: Go to the TeXworks website (https://www.tug.org/texworks/) and download the appropriate installer for your operating system (Windows, macOS, or Linux).

2. **Install TeXworks**: Once the download is complete, run the installer and follow the on-screen instructions to install TeXworks on your computer.

3. **Verify Installation**: After the installation is complete, you can verify that TeXworks has been installed by searching for it in your applications or by running it directly from the location where it was installed.

Compiling a LaTeX File into PDF using TeXworks:

1. **Open article.tex**: Double-click on article.tex. It should automatically open using TeXworks.

2. **Compile the Document**: Click the green "Play" button (or press Ctrl + T on Windows/Linux or Cmd + T on macOS) to compile your LaTeX document into a PDF. TeXworks will run the necessary compilation steps, including processing any LaTeX commands and generating the PDF output.

3. **View the PDF**: Once the compilation process is complete, TeXworks will open the generated PDF file automatically. You can review the output to ensure that it appears as expected.
