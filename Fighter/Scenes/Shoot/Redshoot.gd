extends Area2D

@export var damage: int = 10
@export var shoot_speed: float = 1000.0  

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func shoot_towards(target_position: Vector2) -> void:
	var direction = (target_position - global_position).normalized()
	velocity = direction * shoot_speed
	rotation = direction.angle()


func _process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, global_position)
	queue_free()
