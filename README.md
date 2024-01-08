# MasterThesisRQA
This is the repository for my thesis, which can be found in the folder "Thesis". 

## Running the code
The code is in the folder "Code". If you haven't installed the julia language, install it first at [the Julia website](https://julialang.org/). Make sure the file hierarchy is maintained, so clone the entire repository!

You don't have to install the packages separately! All the packages are contained in a julia environment, and will be installed automatically if the environment is activated. Open a terminal in the containing folder. Then, run the following commands in the command line interface:

    using Pkg
    Pkg.activate(".")
    Pkg.instantiate()

Now, the code will run as-is in an editor of choice. If you don't have an editor, you can use [VSCode](https://code.visualstudio.com/) with the Julia-extension.

