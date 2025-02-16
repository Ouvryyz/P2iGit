extends Node2D

@onready var collision_shape = $Border/Border_down  # Remplace par le chemin exact de ta collision

func _input(event):
	if event.is_action_pressed("test"):  # Remplace "test" par le nom de ton action
		disable_collision()

func disable_collision():
	if collision_shape:
		collision_shape.disabled = true
		await get_tree().create_timer(0.5).timeout  # Attend 1 seconde
		collision_shape.disabled = false
