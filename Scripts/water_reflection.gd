extends AnimatedSprite2D
@onready var player: CharacterBody2D = %Player
@onready var water_reflection: AnimatedSprite2D = %WaterReflection

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	water_reflection.position.x = player.position.x
