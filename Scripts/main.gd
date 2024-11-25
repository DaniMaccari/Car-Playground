extends Node3D

var camera_tween : Tween
var in_menu : bool
@onready var camera : Camera3D = $Camera3D

@onready var menu_ui := $menu_UI
@onready var points_manager := $PointsCounter
@onready var ui_manager := $ingame_UI
var game_started : bool = false

func _ready() -> void:
	print("ready game")
	in_menu = true
	menu_ui.visible = true
	ui_manager.visible = false
	camera.rotation_degrees = Vector3(-13, 0, 0)
	$VehicleBody3D.visible = false
	points_manager.catched_signal.connect(ui_manager.add_point)
	ui_manager.start_signal.connect(start_game)

func start_game() -> void:
	
	get_tree().paused = false
	$VehicleBody3D.visible = true
	points_manager.spawn_collectable()

func menu_to_game() -> void:
	menu_ui.change_scene()
	camera_transition()
	$WaterMesh.show()

func camera_transition() -> void:
	var timer := Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(start_ingameUI)
	
	add_child(timer)
	timer.start()
	
	camera_tween = create_tween()
	camera_tween.set_trans(Tween.TRANS_LINEAR)
	camera_tween.set_parallel(true)
	camera_tween.tween_property(camera, "rotation_degrees", Vector3(-44, 0, 0), 0.6)
	camera_tween.tween_property(camera, "size", 58, 0.6)

func start_ingameUI() -> void:
	print("timeout")
	ui_manager.delay_ready()
	
func _input(event: InputEvent) -> void:
	if !game_started && event is InputEventKey:
		game_started = true
		menu_to_game()
		
