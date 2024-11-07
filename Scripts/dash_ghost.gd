extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween:Tween = get_tree().create_tween()
	
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.connect("finished", on_tween_finished)
	
func on_tween_finished() -> void:
	queue_free()
