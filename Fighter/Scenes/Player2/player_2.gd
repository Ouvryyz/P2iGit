extends CharacterBody2D
class_name Player2

@onready var hitbox = $HitboxArea

func _ready() -> void:
	hitbox.monitoring = false  # Elle doit être désactivée au début
	hitbox.monitorable = true  # Permet d'être détectée par d'autres zones
