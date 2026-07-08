using JuMP
using HiGHS

# Ensembles
crops = ["Corn", "Wheat", "Cotton"]
resources = ["Land", "Labor"]

# Données
revenue = Dict("Corn" => 109.0, "Wheat" => 90.0, "Cotton" => 115.0)
resource_available = Dict("Land" => 100.0, "Labor" => 500.0)

resource_use = Dict(
    ("Land", "Corn") => 1.0, ("Land", "Wheat") => 1.0, ("Land", "Cotton") => 1.0,
    ("Labor", "Corn") => 6.0, ("Labor", "Wheat") => 4.0, ("Labor", "Cotton") => 8.0
)

# Modèle
farm_model = Model(HiGHS.Optimizer)

# Variables
@variable(farm_model, production[c in crops] >= 0)

# Contraintes
@constraint(farm_model, resource_con[r in resources],
    sum(resource_use[(r, c)] * production[c] for c in crops) <= resource_available[r])

# Objectif
@objective(farm_model, Max, sum(revenue[c] * production[c] for c in crops))

# Résolution
optimize!(farm_model)

# Affichage des résultats
println("Statut de la résolution : ", termination_status(farm_model))
println("Profit total optimal = ", objective_value(farm_model))
println("\nProduction par culture :")
for c in crops
    println("  $c = ", value(production[c]), " (coût réduit = ", reduced_cost(production[c]), ")")
end

println("\nUtilisation des ressources :")
for r in resources
    println("  $r = ", value(resource_con[r]), " / ", resource_available[r], " (prix d'ombre = ", shadow_price(resource_con[r]), ")")
end
