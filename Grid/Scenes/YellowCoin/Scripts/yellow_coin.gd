extends RigidBody2D

@export var gravity: float = 980.0  # Gravité appliquée à la pièce
@export var use_button: Button  # Référence au contrôle "Use"
@export var spawn_position: Vector2 = Vector2(200, 100)  # Position initiale de la pièce

var is_active: bool = false

func _ready():
	# Assurer que la pièce est bien cachée au début
	visible = false
	freeze = true
	contact_monitor = true
	max_contacts_reported = 1

	# Connecter le bouton "Use" à la fonction de spawn
	if use_button:
		use_button.pressed.connect(_on_use_pressed)

func _on_use_pressed():
	print("Bouton 'Use' pressé ! Spawn de la pièce.")
	_spawn_coin(spawn_position)

func _physics_process(delta):
	if is_active:
		# Appliquer la gravité pour faire tomber la pièce
		apply_central_force(Vector2(0, gravity * delta))

func _spawn_coin(position: Vector2):
	if not is_active:
		global_position = position
		visible = true
		freeze = false
		is_active = true

func _on_body_entered(_body):
	print("Collision détectée ! Pièce arrêtée.")
	freeze = true
	is_active = false
