extends Node

const PUISSANCE4_SCENE := preload("res://Grid/Scenes/Logic/Logic.tscn")
const FIGHTER_SCENE := preload("res://Fighter/Scenes/Game/Game.tscn")
const PAUSE_MENU_SCENE := preload("res://GameController/PauseMenu.tscn") 

var phase_order := [PUISSANCE4_SCENE, FIGHTER_SCENE, PUISSANCE4_SCENE, FIGHTER_SCENE,PUISSANCE4_SCENE, FIGHTER_SCENE]
var current_phase := 0

const PHASE_DURATION := 20.0

@onready var scene_holder := $SceneHolder

func _ready():
	start_next_phase()

func start_next_phase():
	if current_phase >= phase_order.size():
		print("Fin du jeu !")
		return

	if current_phase > 0 and phase_order[current_phase - 1] == PUISSANCE4_SCENE:
		save_puissance4_state()

	hide_all_jetons()

	
	for child in scene_holder.get_children():
		child.queue_free()

	
	var scene_instance = phase_order[current_phase].instantiate()
	scene_holder.add_child(scene_instance)


	if not get_node_or_null("/root/PauseMenu"):
		var pause_instance = PAUSE_MENU_SCENE.instantiate()
		get_tree().root.add_child(pause_instance)
		pause_instance.name = "PauseMenu"

	
	if phase_order[current_phase] == FIGHTER_SCENE:
		GameState.current_fighter_scene = scene_instance

		
		if scene_instance.has_signal("player_defeated"):
			scene_instance.connect("player_defeated", Callable(self, "_on_player_defeated"))

	
	if phase_order[current_phase] == PUISSANCE4_SCENE:
		if scene_instance.has_signal("puissance4_finished"):
			scene_instance.connect("puissance4_finished", Callable(self, "_on_puissance4_finished"))

	current_phase += 1

	await get_tree().create_timer(PHASE_DURATION).timeout
	start_next_phase()

func _on_player_defeated(who: String):
	print("%s a été vaincu. Retour au menu..." % who)

	if GameState.current_fighter_scene and GameState.current_fighter_scene.has_method("show_defeat_message"):
		GameState.current_fighter_scene.show_defeat_message(who)

	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://GameController/Menu.tscn")

func _on_puissance4_finished(outcome: String):
	if outcome == "victory":
		print("Victoire par score dans Puissance 4.")
	elif outcome == "timeout":
		print("Temps écoulé pour un joueur dans Puissance 4.")

	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://GameController/Menu.tscn")


func hide_all_jetons():
	for jeton in get_tree().get_nodes_in_group("Jetons"):
		jeton.visible = false

func save_puissance4_state():
	var coins = get_tree().get_nodes_in_group("Jetons")
	GameState.saved_jetons.clear()
	for coin in coins:
		GameState.saved_jetons.append({
			"position": coin.global_position,
			"type": coin.coin_type
		})

	var logic_node = scene_holder.get_node("Logic")
	if logic_node:
		GameState.current_player = logic_node.current_player
