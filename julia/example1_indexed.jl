using JuMP
using HiGHS

# Ensembles d'indices
I = ["X1", "X2", "X3"]

# Paramètres
c = Dict("X1" => 109.0, "X2" => 90.0, "X3" => 115.0)
a = Dict("X1" => 6.0,   "X2" => 4.0,  "X3" => 8.0)

# Initialisation du modèle
model = Model(HiGHS.Optimizer)

# Déclaration des variables de décision indexées par l'ensemble I
@variable(model, x[i in I] >= 0)

# Déclaration de la fonction objectif
@objective(model, Max, sum(c[i] * x[i] for i in I))

# Déclaration des contraintes
@constraint(model, Equation2, sum(x[i] for i in I) <= 100)
@constraint(model, Equation3, sum(a[i] * x[i] for i in I) <= 500)

# Résolution
optimize!(model)

# Affichage
println("Statut de résolution : ", termination_status(model))
println("Valeur de l'objectif (Z) = ", objective_value(model))
for i in I
    println("Variable x[$i] = ", value(x[i]))
end
