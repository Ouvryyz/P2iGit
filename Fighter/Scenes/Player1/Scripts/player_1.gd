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

var enemy_inattack_range = false
var enemy_cooldown  = true 
var health = 10
var player_alive = true

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	move()
	enemy_attack()

func _input(event: InputEvent) -> void:
	direction=Input.get_vector("move_left","move_right","move_up","move_down")
	if direction != Vector2.ZERO:
		Last_direction = direction
	if event.is_action_pressed("Dash"):
		dash()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rotate_toward_click(event.position)
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
	ghost.set_property(position, $PlayerRed.scale)
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


func _on_hitbox_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_hitbox_area_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_cooldown == true:
		health = health - 1
		enemy_cooldown = false
		$Attack_cooldown.start()
		print(health)
	


func _on_attack_cooldown_timeout() -> void:
	enemy_cooldown = true
