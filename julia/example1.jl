using JuMP
using HiGHS

# Initialisation du modèle
model = Model(HiGHS.Optimizer)

# Déclaration des variables (positives)
@variable(model, x1 >= 0)
@variable(model, x2 >= 0)
@variable(model, x3 >= 0)

# Déclaration de la fonction objectif (maximisation)
@objective(model, Max, 109*x1 + 90*x2 + 115*x3)

# Déclaration des contraintes
@constraint(model, Equation2, x1 + x2 + x3 <= 100)
@constraint(model, Equation3, 6*x1 + 4*x2 + 8*x3 <= 500)

# Résolution
optimize!(model)

# Affichage
println("Statut de résolution : ", termination_status(model))
println("Valeur de l'objectif (Z) = ", objective_value(model))
println("Variables de décision :")
println("  x1 = ", value(x1), " (coût réduit = ", reduced_cost(x1), ")")
println("  x2 = ", value(x2), " (coût réduit = ", reduced_cost(x2), ")")
println("  x3 = ", value(x3), " (coût réduit = ", reduced_cost(x3), ")")
println("Variables duales (contraintes) :")
println("  Equation2 = ", shadow_price(Equation2))
println("  Equation3 = ", shadow_price(Equation3))
