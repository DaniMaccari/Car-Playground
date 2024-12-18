extends Control

signal start_signal
signal end_signal

var game_points : int = 0
var game_time : int
var timer : Timer
var init_timer : Timer
var init_timeout : int = 1
@export var MAX_TIME : int = 360
var flash_tween : Tween

@onready var points_label := $PointsLabel
@onready var timer_label := $TimerLabel
@onready var flash : ColorRect = $Flash

# Called when the node enters the scene tree for the first time.
func delay_ready() -> void:
	show()
	game_points = 0
	game_time = MAX_TIME
	
	# set start timer
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
	timer.process_mode = Node.PROCESS_MODE_ALWAYS
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout() -> void:
	game_time -= 1
	if game_time <= 0:
		stop_ui()
	elif game_time <= 30:
		$StartLabel.modulate = Color(1, 1, 1, 0.4)
		if game_time == 10:
			$StartLabel.clear()
			$StartLabel.append_text("[center]1")
		elif game_time == 20:
			$StartLabel.clear()
			$StartLabel.append_text("[center]2")
		elif game_time == 30:
			$StartLabel.clear()
			$StartLabel.append_text("[center]3")
	else:
		$StartLabel.modulate = Color(1, 1, 1, 1)
		$StartLabel.clear()
	
	timer_label.value = game_time

func _on_timer_start() -> void:
	print("timer")
	
	if init_timeout == 2:
		$StartLabel.clear()
		$StartLabel.append_text("[center]SET")
	elif init_timeout == 1:
		$StartLabel.clear()
		$StartLabel.append_text("[center]READY")
	elif init_timeout == 0:
		$StartLabel.clear()
		$StartLabel.append_text("[center]GO!")
	elif init_timeout < 0:
		$StartLabel.clear()
		if init_timer != null:
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
	timer.stop()
	$StartLabel.clear()
	
	flash_effect()
	
	await get_tree().create_timer(0.2).timeout
	emit_signal("end_signal")
	
	points_label.visible = false
	timer_label.visible = false

func flash_effect() -> void:
	print(flash)
	flash_tween = create_tween()
	flash_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	flash_tween.set_trans(Tween.TRANS_SPRING)
	flash_tween.tween_property(flash, "modulate:a", 1.0, 0.2)
	flash_tween.tween_property(flash, "modulate:a", 0.0, 0.8)
	
func add_point() -> void:
	game_points += 1
	
	game_time += 30
	if game_time > MAX_TIME:
		game_time = MAX_TIME
	timer_label.value = game_time
	points_label.clear()
	points_label.append_text( "%03d" % game_points)
	
func get_score() -> int:
	return game_points
