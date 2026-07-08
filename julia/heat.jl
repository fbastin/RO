using JuMP
using HiGHS

# Ensembles 
I = ["A", "B", "C", "D"] # flux (streams)
J = [1, 2, 3, 4]         # échangeurs (exchangers)

# Coûts d'affectation du flux i à l'échangeur j
C = Dict(
    ("A", 1) => 94.0, ("A", 2) => 1.0,  ("A", 3) => 54.0, ("A", 4) => 68.0,
    ("B", 1) => 74.0, ("B", 2) => 10.0, ("B", 3) => 88.0, ("B", 4) => 82.0,
    ("C", 1) => 73.0, ("C", 2) => 88.0, ("C", 3) => 8.0,  ("C", 4) => 76.0,
    ("D", 1) => 11.0, ("D", 2) => 74.0, ("D", 3) => 81.0, ("D", 4) => 21.0
)

# Modèle
heat_model = Model(HiGHS.Optimizer)

# Variables binaires
@variable(heat_model, x[I, J], Bin)

# Contraintes
@constraint(heat_model, ass_i[j in J], sum(x[i, j] for i in I) == 1)
@constraint(heat_model, ass_j[i in I], sum(x[i, j] for j in J) == 1)

# Objectif
@objective(heat_model, Min, sum(C[(i, j)] * x[i, j] for i in I, j in J))

# Supprimer l'affichage des logs
set_silent(heat_model)

# Résolution
optimize!(heat_model)

# Affichage des résultats
println("Statut de la résolution : ", termination_status(heat_model))
println("Coût minimal optimal Z = ", objective_value(heat_model))
println("\nAffectations optimales :")
for i in I, j in J
    if value(x[i, j]) > 0.5
        println("  Flux $i affecté à l'échangeur $j")
    end
end
