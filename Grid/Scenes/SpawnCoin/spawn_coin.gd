extends Node2D

var Yellowcoin_scene = preload("res://Grid/Scenes/YellowCoin/YellowCoin.tscn")
var Redcoin_scene = preload("res://Grid/Scenes/RedCoin/RedCoin.tscn")


func yellowspawn(spawn_pos: Vector2):
	var coin_instance = Yellowcoin_scene.instantiate()  # Instancie la pièce jaune
	coin_instance.global_position = spawn_pos             # Positionne la pièce à l'endroit souhaité
	get_tree().current_scene.add_child(coin_instance)       # Ajoute la pièce à la scène actuelle

func redspawn(spawn_pos: Vector2):
	var coin_instance = Redcoin_scene.instantiate()       # Instancie la pièce rouge
	coin_instance.global_position = spawn_pos             # Positionne la pièce à l'endroit souhaité
	get_tree().current_scene.add_child(coin_instance)       # Ajoute la pièce à la scène actuelle
