extends Sprite2D

func drop(target_position):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_position, 0.5).set_trans(Tween.TRANS_BOUNCE)
