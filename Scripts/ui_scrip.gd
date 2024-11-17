extends Control

var game_points : int = 0
var game_time : int
var timer : Timer
var init_timer : Timer
const MAX_TIME : int = 360

@onready var points_label := $PointsLabel
@onready var timer_label := $TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set points
	game_time = MAX_TIME
	points_label.clear()
	points_label.append_text( "%03d" % game_points)
	
	# set timer
	timer = Timer.new()
	timer.wait_time = 0.1
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout() -> void:
	game_time -= 1
	
	timer_label.value = game_time
	pass

func add_point() -> void:
	game_points += 1
	
	game_time += 30
	if game_time > MAX_TIME:
		game_time = MAX_TIME
	timer_label.value = game_time
	points_label.clear()
	points_label.append_text( "%03d" % game_points)
