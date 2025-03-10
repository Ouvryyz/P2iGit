extends CharacterBody2D
class_name Player2

var health: int = 100  

@onready var hitbox = $HitboxArea  

func _physics_process(delta: float) -> void:
	for area in hitbox.get_overlapping_areas():
		print("Zone détectée :", area)
		if area.get_parent().is_in_group("player1"):
			take_damage(20)
			

func _ready() -> void:
	print("Player 2 prêt avec", health, "PV")
	hitbox.monitoring = true  
	hitbox.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))

func take_damage(amount: int) -> void:
	health -= amount
	print("Player 2 touché ! Vie restante :", health)
	if health <= 0:
		die()

func die() -> void:
	print("Player 2 est éliminé !")
	queue_free() 


	 


func _on_hitbox_area_body_entered(body: Node2D) -> void:
	if hitbox.get_parent().is_in_group("player1"):
		take_damage(20) 
