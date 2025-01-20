extends CharacterBody2D
class_name Player

@export_range(0.0,1.0) var accel_factor : float = 01
@export_range(0.0,1.0) var rotation_accel_factor : float = 01


@export var max_speed : float = 200.0
var speed : float = 0.0

var direction := Vector2.ZERO
var Last_direction := Vector2.ZERO


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	move()
	rotate_toward_mouse()


func _input(event: InputEvent) -> void:
	direction=Input.get_vector("move_left","move_right","move_up","move_down")
	print(direction)
	if direction != Vector2.ZERO:
		Last_direction = direction
	




func move()-> void:
	
	if direction == Vector2.ZERO :
		speed=lerp(speed,0.0,accel_factor)	
	else:	
		speed=lerp(speed,max_speed,accel_factor)
		
	
	velocity = Last_direction * speed
	move_and_slide()


func rotate_toward_mouse()-> void:
	var mouse_pos = get_global_mouse_position()
	var angle = global_position.angle_to_point(mouse_pos)
	rotation = lerp_angle(rotation,angle, rotation_accel_factor)
