extends Node2D

@onready var collision_shape = $Border/Border_down  

func _input(event):
	if event.is_action_pressed("test"):  
		disable_collision()

func disable_collision():
	if collision_shape:
		collision_shape.disabled = true
		await get_tree().create_timer(0.5).timeout  
		collision_shape.disabled = false
