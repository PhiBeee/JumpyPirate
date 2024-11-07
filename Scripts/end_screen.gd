extends Control
@onready var pointLabel: Label = $TextureRect/PointLabel

func _ready() -> void:
	pointLabel.text = "You finished with: \n"+str(GlobalVars.points)+" points"
	GlobalVars.points = 0
	GlobalVars.deaths = 0


func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_close_pressed() -> void:
	get_tree().quit()
