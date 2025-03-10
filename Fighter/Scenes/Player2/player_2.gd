extends CharacterBody2D
class_name Player2

var health: int = 100  # Points de vie du Player 2

func _ready() -> void:
<<<<<<< Updated upstream
	hitbox.monitoring = false  
	hitbox.monitorable = true  
=======
	print("Player 2 prêt avec", health, "PV")

func take_damage(amount: int) -> void:
	health -= amount
	print("Player 2 touché ! Vie restante :", health)
	if health <= 0:
		die()

func die() -> void:
	print("Player 2 est éliminé !")
	queue_free()  # Supprime l'objet de la scène
>>>>>>> Stashed changes
