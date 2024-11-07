extends Path2D
@onready var player: CharacterBody2D = %Player
@onready var respawn: Marker2D = %Respawn
@onready var path_follow_2d: PathFollow2D = $PathFollow2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if path_follow_2d.progress_ratio != 1:
		path_follow_2d.progress_ratio += delta * 0.20
	else: path_follow_2d.progress_ratio = 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GlobalVars.deaths += 1
		player.position = respawn.position
