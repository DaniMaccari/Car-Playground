extends Control

signal start_signal

var game_points : int = 0
var game_time : int
var timer : Timer
var init_timer : Timer
var init_timeout : int = 1
const MAX_TIME : int = 360


@onready var points_label := $PointsLabel
@onready var timer_label := $TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set start timer
	$EndPointsLabel.visible = false
	init_timer = Timer.new()
	init_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	init_timer.wait_time = 0.6
	init_timer.autostart = true
	init_timer.one_shot = false
	init_timer.timeout.connect(_on_timer_start)
	add_child(init_timer)
	
	# set points
	points_label.visible = false
	points_label.clear()
	points_label.append_text( "%03d" % game_points)
	
	# set timer
	game_time = MAX_TIME
	timer_label.visible = false
	timer = Timer.new()
	timer.wait_time = 0.1
	#timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	
	
func _on_timer_timeout() -> void:
	game_time -= 1
	if game_time <= 0:
		stop_ui()
	timer_label.value = game_time

func _on_timer_start() -> void:
	print("timer")
	if init_timeout == 0:
		$StartLabel.clear()
		$StartLabel.append_text("[center]GO!")
	elif init_timeout < 0:
		$StartLabel.clear()
		$StartLabel.append_text("")
		init_timer.queue_free()
		start_ui()
	init_timeout -= 1

func start_ui() -> void:
	emit_signal("start_signal")
	
	points_label.visible = true
	timer_label.visible = true
	timer.start()

func stop_ui() -> void:
	get_tree().paused = true
	$StartLabel.clear()
	$StartLabel.append_text("[center]STOP")
	$EndPointsLabel.clear()
	$EndPointsLabel.append_text("[center]%03d points" % game_points)
	$EndPointsLabel.visible = true
	
	timer.stop()
	points_label.visible = false
	timer_label.visible = false
	pass

func add_point() -> void:
	game_points += 1
	
	game_time += 30
	if game_time > MAX_TIME:
		game_time = MAX_TIME
	timer_label.value = game_time
	points_label.clear()
	points_label.append_text( "%03d" % game_points)
