extends Node

@onready var points_label: Label = %PointsLabel
@onready var points_timer: Timer = $PointsTimer

const START_SCORE = 50000
const SCORE_DECAY = 416
const DEATH_PENALTY = 1500
var score_minimum = 0

func _process(delta: float) -> void:
	var timeElapsed = points_timer.wait_time - points_timer.time_left
	# Dying makes Score from going fast go away faster
	var timeScore = SCORE_DECAY*timeElapsed + DEATH_PENALTY*GlobalVars.deaths
	if timeScore < START_SCORE:
		GlobalVars.points = int((START_SCORE - (timeScore)) + score_minimum)
	else: GlobalVars.points = score_minimum
	
	points_label.text = "Points: " + str(GlobalVars.points)

func add_points(collectableName: String):
	if "Coin" in collectableName: score_minimum += 250
	elif "Diamond" in collectableName: score_minimum += 1000
	elif "Ruby" in collectableName: score_minimum += 5000
	
