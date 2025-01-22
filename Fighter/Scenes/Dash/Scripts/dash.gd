extends CharacterBody2D
class_name DashPlayer

@export var speed : float = 200.0
@export var dash_speed : float = 1000.0
@export var dash_duration : float = 0.3

var is_dashing : bool = false
var dash_timer : float = 0.0
var direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Check for dash input
	if Input.is_action_just_pressed("Dash") and not is_dashing:
		start_dash()

	# Handle dashing state
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			end_dash()

	# Get movement input
	if not is_dashing:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Calculate velocity
	if is_dashing:
		velocity = direction * dash_speed
	else:
		velocity = direction * speed

	move_and_slide()

func start_dash() -> void:
	is_dashing = true
	dash_timer = dash_duration
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT  # Default dash direction if no input

func end_dash() -> void:
	is_dashing = false
