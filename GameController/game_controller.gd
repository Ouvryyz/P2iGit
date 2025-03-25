extends Node

# Chargement des scènes
const PUISSANCE4_SCENE := preload("res://Grid/Scenes/Logic/Logic.tscn")
const FIGHTER_SCENE := preload("res://Fighter/Scenes/Game/Game.tscn")

# Ordre des phases : 2 cycles (Puissance4 -> Fighter)
var phase_order := [PUISSANCE4_SCENE, FIGHTER_SCENE, PUISSANCE4_SCENE, FIGHTER_SCENE]
var current_phase := 0

# Durée d'une phase (en secondes)
const PHASE_DURATION := 10.0

@onready var scene_holder := $SceneHolder

func _ready():
	start_next_phase()

func start_next_phase():
	if current_phase >= phase_order.size():
		print("Fin du jeu !")
		return

	# 🧹 Cacher les jetons avant de supprimer la scène précédente
	hide_all_jetons()

	# Nettoyage de la scène précédente
	for child in scene_holder.get_children():
		child.queue_free()

	# Chargement de la nouvelle scène
	var scene_instance = phase_order[current_phase].instantiate()
	scene_holder.add_child(scene_instance)

	current_phase += 1

	await get_tree().create_timer(PHASE_DURATION).timeout
	start_next_phase()

func hide_all_jetons():
	for jeton in get_tree().get_nodes_in_group("Jetons"):
		jeton.visible = false
