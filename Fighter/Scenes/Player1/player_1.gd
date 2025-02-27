extends CharacterBody2D
class_name Player

@export var dash_node : PackedScene
@onready var ghost_timer = $GhostTimer
@onready var particles =$GPUParticles2D

@export_range(0.0,1.0) var accel_factor : float = 01
@export_range(0.0,1.0) var rotation_accel_factor : float = 01

	
@export var max_speed : float = 200.0
var speed : float = 0.0

var direction := Vector2.ZERO
var Last_direction := Vector2.ZERO

@onready var hitbox = $HitboxArea
@onready var attack_cooldown = $Attack_cooldown
@onready var anim_player = $Player1 


var is_attacking = false

func _ready() -> void:
	hitbox.monitoring = false  # Commence désactivé
	hitbox.monitorable = true  # Peut être détecté par d'autres zones
	await get_tree().create_timer(0.1).timeout  # Petit délai pour éviter les bugs d'initialisation
	hitbox.monitoring = false  # S'assurer que la hitbox commence bien désactivée

func _physics_process(delta: float) -> void:
	move()
	if not is_attacking and anim_player.animation == "attack":
		anim_player.play("idle")  

func _input(event: InputEvent) -> void:
	direction=Input.get_vector("move_left","move_right","move_up","move_down")
	if direction != Vector2.ZERO:
		Last_direction = direction
	if event.is_action_pressed("Dash"):
		dash()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rotate_toward_click(event.position)
		attack()

func attack():
	if is_attacking or not attack_cooldown.is_stopped():
		return  

	print("Attaque déclenchée")
	is_attacking = true
	hitbox.monitoring = true  # Active la hitbox
	attack_cooldown.start()  # Démarre le cooldown

	anim_player.play("attack")  # Joue l’animation d’attaque

	await get_tree().create_timer(0.3).timeout  # Temps de l'attaque
	hitbox.monitoring = false  # Désactive la hitbox
	is_attacking = false


func move()-> void:
	
	if direction == Vector2.ZERO :
		speed=lerp(speed,0.0,accel_factor)	
	else:	
		speed=lerp(speed,max_speed,accel_factor)
		
	
	velocity = Last_direction * speed
	move_and_slide()

func rotate_toward_click(mouse_pos: Vector2) -> void:
	var angle = (mouse_pos - global_position).angle()
	rotation = angle

func add_ghost():
	var ghost = dash_node.instantiate()
	ghost.set_property(position, $Player1.scale)
	get_tree().current_scene.add_child(ghost)

func _on_ghost_timer_timeout() -> void:
	add_ghost()

func dash():
	ghost_timer.start()
	particles.emitting = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + velocity * 1.5, 0.45)
	
	await tween.finished
	ghost_timer.stop()
	particles.emitting = false



func _on_hitbox_area_area_entered(area: Area2D) -> void:
	print("Zone touchée !", area)  # Vérifier si le signal est déclenché
	if area.is_in_group("enemy"):
		print("L'ennemi est touché !")



func _on_attack_cooldown_timeout() -> void:
	print("Cooldown terminé, attaque possible")
	is_attacking = false
