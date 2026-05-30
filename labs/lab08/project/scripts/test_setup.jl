#!/usr/bin/env julia
# test_setup.jl

using DrWatson
projectdir() = dirname(@__DIR__)  # указываем корень проекта вручную

println("✅ Проект активирован: ", projectdir())

# Проверка пакетов
packages = [
    "DrWatson",
    "DifferentialEquations",
    "Plots",
    "DataFrames",
    "CSV",
    "JLD2",
    "Literate",
    "IJulia",
    "BenchmarkTools",
    "Quarto"
]

println("\nПроверка пакетов:")
for pkg in packages
    try
        eval(Meta.parse("using $pkg"))
        println(" ✓ $pkg")
    catch e
        println(" ✗ $pkg: Ошибка загрузки")
    end
end

# Проверка путей
println("\nСтруктура проекта:")
println(" Корень: ", projectdir())
println(" Данные: ", joinpath(projectdir(), "data"))
println(" Скрипты: ", joinpath(projectdir(), "src"))
println(" Графики: ", joinpath(projectdir(), "plots"))