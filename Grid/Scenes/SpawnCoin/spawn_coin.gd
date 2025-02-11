extends Node2D

var Yellowcoin_scene = preload("res://Grid/Scenes/YellowCoin/YellowCoin.tscn")
var Redcoin_scene = preload("res://Grid/Scenes/RedCoin/RedCoin.tscn")


func yellowspawn(spawn_pos: Vector2):
	var coin_instance = Yellowcoin_scene.instantiate()  
	coin_instance.global_position = spawn_pos             
	get_tree().current_scene.add_child(coin_instance)       

func redspawn(spawn_pos: Vector2):
	var coin_instance = Redcoin_scene.instantiate()       
	coin_instance.global_position = spawn_pos             
	get_tree().current_scene.add_child(coin_instance)       
