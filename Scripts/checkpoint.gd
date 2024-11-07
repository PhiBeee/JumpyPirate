extends Area2D
@onready var player: CharacterBody2D = %Player
@onready var respawn: Marker2D = %Respawn

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		respawn.position = player.position