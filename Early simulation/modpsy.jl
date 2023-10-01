using Gadfly
using DataFrames
using Random

# DATA GENERATION
function generateData()
    Smax, Rs, λs, τx, P, Rb, λb, L, τy, S, α, β, τz = 10, 1, 0.1, 14, 10, 1.04, 0.05, 1.01, 14, 10, 0.5, 0.5, 1 

    Li = collect(1:1200000)
    dt = 0.01
    Lt = [dt * i for i in Li]
    y = 0.01 
    x = 0.0
    z = 0.0
    f = 0.0
    Ly = []
    Lx = []
    Lz = []
    Lf = []

    for i in Li
        a = rand() - 0.5
        dx = (Smax /(1 + exp((Rs - y) / λs)) - x) / τx
        dy = (P / (1 + exp((Rb - y) / λb)) + L * f - x * y- z) 
        dz = (S * (α * x + β * y) * a - z) / τz
        df = (y - 1.0 * f)/720
        y = y + dy * t 
        x = x + dx * dt
        z = z + dz * dt
        f = f + df * dt
        push!(Ly, y)
        push!(Lx, x)
        push!(Lz, z)
        push!(Lf, f)
    end
end

function ()
