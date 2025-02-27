extends CharacterBody2D
class_name Player2

@onready var hitbox = $HitboxArea

func _ready() -> void:
	hitbox.monitoring = false  
	hitbox.monitorable = true  
