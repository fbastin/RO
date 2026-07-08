using JuMP
using HiGHS

# Modèle
prod_model = Model(HiGHS.Optimizer)

# Variables positives
@variable(prod_model, x1 >= 0) # produit 1
@variable(prod_model, x2 >= 0) # produit 2
@variable(prod_model, x3 >= 0) # produit 3

# Variables binaires (activation des coûts fixes)
@variable(prod_model, y1, Bin)
@variable(prod_model, y2, Bin)

# Contraintes
@constraint(prod_model, ressource, 0.2*x1 + 0.4*x2 + 0.2*x3 <= 1)
@constraint(prod_model, upper1, x1 <= 3*y1)
@constraint(prod_model, upper2, x2 <= 2*y2)
@constraint(prod_model, upper3, x3 <= 5)

# Objectif
@objective(prod_model, Max, 2*x1 + 3*x2 + 0.8*x3 - 3*y1 - 2*y2)

# Critère d'optimalité MIP Gap (5%)
set_attribute(prod_model, "mip_rel_gap", 0.05)

# Résolution
optimize!(prod_model)

# Affichage des résultats
println("Statut de la résolution : ", termination_status(prod_model))
println("Profit total optimal = ", objective_value(prod_model))
println("\nNiveau de production :")
println("  Produit 1 (x1) = ", value(x1), " (Coût fixe activé (y1) = ", value(y1), ")")
println("  Produit 2 (x2) = ", value(x2), " (Coût fixe activé (y2) = ", value(y2), ")")
println("  Produit 3 (x3) = ", value(x3))
