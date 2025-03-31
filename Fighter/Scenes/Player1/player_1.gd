extends CharacterBody2D
class_name Player

@export var dash_node : PackedScene
@onready var ghost_timer = $GhostTimer
@onready var particles = $GPUParticles2D

@export_range(0.0,1.0) var accel_factor : float = 0.1
@export_range(0.0,1.0) var rotation_accel_factor : float = 0.1

@export var ShootScene = preload("res://Fighter/Scenes/Shoot/Shoot.tscn") 

@export var max_speed : float = 200.0
var speed : float = 0.0

var direction := Vector2.ZERO
var Last_direction := Vector2.ZERO

@onready var hitbox = $HitboxArea
@onready var attack_cooldown = $Attack_cooldown
@onready var anim_player = $Player1

var is_attacking = false

var AttackScene = preload("res://Fighter/Scenes/Attack/Attack.tscn")
var current_attack = null  # Variable pour stocker l'attaque en cours


func _ready() -> void:
	hitbox.monitoring = false  
	hitbox.monitorable = true  
	await get_tree().create_timer(0.1).timeout 
	hitbox.monitoring = false  

func _physics_process(delta: float) -> void:
	move()
	update_rotation()

	# Si une attaque est active, mettre à jour sa position
	if current_attack:
		update_attack_position(current_attack)

	if not is_attacking and anim_player.animation == "attack":
		anim_player.play("idle")  

func _input(event: InputEvent) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		Last_direction = direction
	if event.is_action_pressed("Dash"):
		dash()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		attack()
	if Input.is_action_just_pressed("shoot"):
		shoot_projectile()

func attack():
	if is_attacking or not attack_cooldown.is_stopped():
		return  

	print("Attaque déclenchée")
	is_attacking = true
	attack_cooldown.start() 

	anim_player.play("attack")  

	# Instancier l'attaque
	var attack_instance = AttackScene.instantiate()
	
	# Attacher l'attaque à Player1 pour qu'elle le suive
	add_child(attack_instance)

	# Placer l'attaque devant le joueur
	update_attack_position(attack_instance)

	# Garder une référence pour la mettre à jour chaque frame
	current_attack = attack_instance

	await get_tree().create_timer(0.3).timeout 
	is_attacking = false
	current_attack = null  # Supprime la référence une fois l'attaque terminée
func update_attack_position(attack_instance):
	if attack_instance:
		attack_instance.global_position = global_position + Last_direction.normalized() * 50



func shoot_projectile():
	if not ShootScene:
		print("Erreur : ShootScene non assignée !")
		return

	var projectile = ShootScene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position

	# Tir dans la direction actuelle (rectiligne devant le joueur)
	if Last_direction == Vector2.ZERO:
		Last_direction = Vector2.RIGHT  # Valeur par défaut si jamais aucune direction n’est enregistrée

	projectile.shoot_towards(global_position + Last_direction.normalized() * 100)



func move() -> void:
	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, accel_factor)    
	else:    
		speed = lerp(speed, max_speed, accel_factor)
	
	velocity = Last_direction * speed
	move_and_slide()


func update_rotation() -> void:
	if direction != Vector2.ZERO:
		rotation = direction.angle()  
func add_ghost():
	var ghost = dash_node.instantiate()
	ghost.position = $Player1.global_position
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
	print("Zone touchée !", area)  
	if area.is_in_group("enemy"):
		print("L'ennemi est touché !")

func _on_attack_cooldown_timeout() -> void:
	print("Cooldown terminé, attaque possible")
	is_attacking = false
