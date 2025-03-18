extends Area2D

@export var damage: int = 10  

func _ready() -> void:
	
	connect("body_entered", Callable(self, "_on_body_entered"))
	await get_tree().create_timer(0.3).timeout
	queue_free()

func _on_body_entered(body: Node) -> void:

	if body.has_method("take_damage"):
		body.take_damage(damage)
