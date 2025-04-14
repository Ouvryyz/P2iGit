extends CharacterBody2D
class_name Player1

@export var max_health: int = 100
var current_health: int = max_health


var can_heal: bool = true
@export var heal_cooldown_duration: float = 15.0


var knockback_velocity := Vector2.ZERO
@export var knockback_strength: float = 200.0  
@export var knockback_decay: float = 0.9  

### Input Player 1


@export var dash_speed: float = 700.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 4.0
var can_dash: bool = true


var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO

@onready var dash_particles = $DashParticles


@export_range(0.0,1.0) var accel_factor : float = 0.1
@export_range(0.0,1.0) var rotation_accel_factor : float = 0.1

@export var ShootScene = preload("res://Fighter/Scenes/Shoot/RedShoot.tscn") 
@export var shoot_cooldown_duration: float = 0.7  
var can_shoot: bool = true

@export var max_speed : float = 200.0
var speed : float = 0.0

var direction := Vector2.ZERO
var Last_direction := Vector2.ZERO

@onready var hitbox = $HitboxArea
@onready var attack_cooldown = $Attack_cooldown
@onready var anim_player = $Player1

var is_attacking = false

var AttackScene = preload("res://Fighter/Scenes/Attack/Attack.tscn")
var current_attack = null  


func _ready() -> void:
	hitbox.monitoring = false  
	hitbox.monitorable = true  
	await get_tree().create_timer(0.1).timeout 
	hitbox.monitoring = false  

	# Initialisation des PV sauvegardés
	if GameState.player1_health > 0 and GameState.player1_health <= max_health:
		current_health = GameState.player1_health
	else:
		current_health = max_health
		GameState.player1_health = max_health

	print("🔁 Player1 loaded health:", current_health)

func _physics_process(delta: float) -> void:
	if is_dashing:
		velocity = dash_direction * dash_speed
	else:
		move()
		update_rotation()

	move_and_slide()

	if current_attack:
		update_attack_position(current_attack)

	if not is_attacking and anim_player.animation == "attack2":
		anim_player.play("idle")

	if knockback_velocity.length() > 1.0:
		velocity = knockback_velocity
		knockback_velocity *= knockback_decay


func _input(event: InputEvent) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		Last_direction = direction
	if event.is_action_pressed("Dash"):
		dash()
	if Input.is_action_just_pressed("Use"):
		attack()
	if Input.is_action_just_pressed("shoot"):
		shoot_projectile()
	if event.is_action_pressed("heal"):
		if can_heal:
			cast_heal_spell()
		else:
			print("Le soin est en recharge. Veuillez patienter...")


func cast_heal_spell() -> void:
	var heal_amount = 20  
	heal(heal_amount)
	print("Sort de soin lancé : +", heal_amount, " PV")
	can_heal = false
	start_heal_cooldown()


func start_heal_cooldown() -> void:
	await get_tree().create_timer(heal_cooldown_duration).timeout
	can_heal = true
	print("Le soin est de nouveau disponible.")


func heal(amount: int) -> void:
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	print("Player1 soigné de ", amount, " points. Vie actuelle : ", current_health)
	GameState.player1_health = current_health

	if GameState.current_fighter_scene:
		GameState.current_fighter_scene.update_player1_life_bar(current_health)
		GameState.current_fighter_scene.start_cooldown()




func take_damage(damage: int, attack_position: Vector2) -> void:
	

	current_health -= damage
	print("Player1 a reçu ", damage, " points de dégâts. Vie restante : ", current_health)

	var knockback_direction = (global_position - attack_position).normalized()
	knockback_velocity = knockback_direction * knockback_strength 

	if current_health <= 0:
		die()
	GameState.player1_health = current_health
	if GameState.current_fighter_scene:
		GameState.current_fighter_scene.update_player1_life_bar(current_health)


func die() -> void:
	print("Player1 est mort.")
	if GameState.current_fighter_scene:
		GameState.current_fighter_scene.notify_player_death("Player1")
	queue_free()



func attack():
	if is_attacking or not attack_cooldown.is_stopped():
		return  

	print("Attaque déclenchée")
	is_attacking = true
	attack_cooldown.start() 

	anim_player.play("attack2")  


	var attack_instance = AttackScene.instantiate()
	

	add_child(attack_instance)


	update_attack_position(attack_instance)

	
	current_attack = attack_instance

	await get_tree().create_timer(0.3).timeout 
	is_attacking = false
	current_attack = null  

func update_attack_position(attack_instance):
	
	if attack_instance:
		attack_instance.global_position = global_position + Last_direction.normalized() * 50

func shoot_projectile():
	if not can_shoot or not ShootScene:
		return

	can_shoot = false 

	var projectile = ShootScene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position

	if Last_direction == Vector2.ZERO:
		Last_direction = Vector2.RIGHT

	projectile.shoot_towards(global_position + Last_direction.normalized() * 100)

	start_shoot_cooldown()


func start_shoot_cooldown() -> void:
	await get_tree().create_timer(shoot_cooldown_duration).timeout
	can_shoot = true


func move() -> void:
	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, accel_factor)    
	else:    
		speed = lerp(speed, max_speed, accel_factor)
	
	velocity = Last_direction * speed
	move_and_slide()

func dash():
	if is_dashing or not can_dash:
		return

	is_dashing = true
	can_dash = false
	dash_direction = Last_direction.normalized()
	dash_particles.emitting = true

	
	if GameState.current_fighter_scene:
		GameState.current_fighter_scene.start_dash_cooldown(dash_cooldown)

	
	await get_tree().create_timer(dash_duration).timeout

	is_dashing = false
	dash_particles.emitting = false

	
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true



func start_dash_cooldown() -> void:
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true
	print("Dash prêt !")





func update_rotation() -> void:
	if direction != Vector2.ZERO:
		rotation = direction.angle()  



func _on_hitbox_area_area_entered(area: Area2D) -> void:
	print("Zone touchée !", area)  
	if area.is_in_group("enemy"):
		print("L'ennemi est touché !")

func _on_attack_cooldown_timeout() -> void:
	print("Cooldown terminé, attaque possible")
	is_attacking = false
