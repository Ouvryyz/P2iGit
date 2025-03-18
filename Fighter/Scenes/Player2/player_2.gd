extends CharacterBody2D
class_name Player2

@export var max_health: int = 100
var current_health: int = max_health

# Variable pour gérer le cooldown du soin
var can_heal: bool = true
@export var heal_cooldown_duration: float = 15.0

func _ready() -> void:
	current_health = max_health

func _input(event: InputEvent) -> void:
	# Lancer le soin si l'action "heal" est pressée et si le cooldown est terminé
	if event.is_action_pressed("heal"):
		if can_heal:
			cast_heal_spell()
		else:
			print("Le soin est en recharge. Veuillez patienter...")

# Fonction qui applique le soin et lance le cooldown
func cast_heal_spell() -> void:
	var heal_amount = 20  # Points de vie restaurés
	heal(heal_amount)
	print("Sort de soin lancé : +", heal_amount, " PV")
	can_heal = false
	start_heal_cooldown()

# Fonction de cooldown qui réactive la possibilité de soigner après 15 secondes
func start_heal_cooldown() -> void:
	await get_tree().create_timer(heal_cooldown_duration).timeout
	can_heal = true
	print("Le soin est de nouveau disponible.")

# Méthode qui augmente la vie du joueur
func heal(amount: int) -> void:
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	print("Player2 soigné de ", amount, " points. Vie actuelle : ", current_health)


func take_damage(damage: int) -> void:
	current_health -= damage
	print("Player2 a reçu ", damage, " points de dégâts. Vie restante : ", current_health)
	
	# Vous pouvez ajouter ici un retour visuel (animation, flash, etc.)
	if current_health <= 0:
		die()


func die() -> void:
	print("Player2 est mort.")
	queue_free()
