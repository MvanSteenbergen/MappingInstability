using Gadfly
using DataFrames
using Random

# DATA GENERATION
function generateData(Smax, Rs, λs, τx, P, Rb, λb, L, τy, S, α, β, τz)

    Li = collect(1:1200000)
    δt = 0.01
    Lt = [dt * i for i in Li]
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

    return Ly, Lx, Lz, Lf, Lt
end

data = generateData(10, 1, 0.1, 14, 10, 1.04, 0.05, 1.01, 14, 10, 0.5, 0.5, 1 )
