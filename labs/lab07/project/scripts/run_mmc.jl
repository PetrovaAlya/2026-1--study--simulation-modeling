using DrWatson
using StableRNGs
using Distributions
using ConcurrentSim
using ResumableFunctions
using DataFrames
using Plots
using CSV

# Указываем корень проекта вручную
project_root = dirname(@__DIR__)
srcdir() = joinpath(project_root, "src")
datadir() = joinpath(project_root, "data")
plotsdir() = joinpath(project_root, "plots")

# Создаём папки, если их нет
mkpath(datadir())
mkpath(plotsdir())

include(joinpath(srcdir(), "mmc_logic.jl"))

# Параметры симуляции
rng = StableRNG(123)
num_customers = 500

num_servers = 2
mu = 1.0 / 2
lam = 0.9
arrival_dist = Exponential(1 / lam)
service_dist = Exponential(1 / mu)

times_data = DataFrame(id = Int[], arrival = Float64[], wait = Float64[])

function setup_and_run()
    sim = Simulation()
    server = Resource(sim, num_servers)
    arrival_time = 0.0
    for i in 1:num_customers
        arrival_time += rand(rng, arrival_dist)
        @process customer(sim, server, i, arrival_time, service_dist, rng, times_data)
    end
    run(sim)
end

setup_and_run()

CSV.write(joinpath(datadir(), "sim_results_mmc.csv"), times_data)

p1 = histogram(times_data.wait,
    title = "Распределение времени ожидания (M/M/c)",
    xlabel = "Время ожидания в очереди",
    ylabel = "Частота",
    label = "Заявки",
    color = :blue)

p2 = plot(times_data.arrival, times_data.id,
    title = "Поток заявок",
    xlabel = "Момент времени t",
    ylabel = "ID клиента",
    label = "Прибытие",
    color = :red)

final_plot = plot(p1, p2, layout = (2, 1), size = (800, 600))
savefig(joinpath(plotsdir(), "mmc_analysis.png"))

println("Моделирование завершено. Результаты в data/ и plots/")