using JuMP
using HiGHS

# Ensembles
beers = ["light", "dark"]
inputs = ["malt", "hops", "yeast"]

# Paramètres
r = Dict("malt" => 75.0, "hops" => 60.0, "yeast" => 50.0)
p = Dict("light" => 2.0, "dark" => 1.0)

a = Dict(
    ("malt", "light") => 2.0, ("malt", "dark") => 3.0,
    ("hops", "light") => 3.0, ("hops", "dark") => 1.0,
    ("yeast", "light") => 2.0, ("yeast", "dark") => 1.67
)

# Modèle
beer_model = Model(HiGHS.Optimizer)

# Variables
@variable(beer_model, x[b in beers] >= 0)

# Contraintes
@constraint(beer_model, supply[i in inputs], 
    sum(a[(i, b)] * x[b] for b in beers) <= r[i])

# Objectif
@objective(beer_model, Max, sum(p[b] * x[b] for b in beers))

# Résolution
optimize!(beer_model)

# Affichage des résultats
println("Statut de la résolution : ", termination_status(beer_model))
println("Profit total optimal = ", objective_value(beer_model))
for b in beers
    println("Production de bière $b = ", value(x[b]))
end
