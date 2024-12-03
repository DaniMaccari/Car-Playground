extends Node3D

var game_started : bool = false

var camera_tween : Tween
const MENU_CAM_DEG : Vector3 = Vector3(-15, 0, 0)
const INGAME_CAM_DEG : Vector3 = Vector3(-44, 0, 0)
const MENU_CAM_SIZE : int = 43
const  INGAME_CAM_SIZE : int = 58
@onready var camera : Camera3D = $Camera3D

@onready var menu_ui := $menu_UI
@onready var points_manager := $PointsCounter
@onready var ui_manager := $ingame_UI

@onready var water_position := $WaterMesh

func _ready() -> void:
	
	print("ready game")
	menu_ui.visible = true
	ui_manager.visible = false
	camera.rotation_degrees = MENU_CAM_DEG
	$VehicleBody3D.visible = false
	points_manager.catched_signal.connect(ui_manager.add_point)
	ui_manager.start_signal.connect(start_game)
	ui_manager.end_signal.connect(end_game)

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
	camera_tween.tween_property(camera, "rotation_degrees", INGAME_CAM_DEG, 0.6)
	camera_tween.tween_property(camera, "size", INGAME_CAM_SIZE, 0.6)

func start_ingameUI() -> void:
	print("timeout")
	ui_manager.delay_ready()

func end_game() -> void:
	
	camera.rotation_degrees = MENU_CAM_DEG
	camera.size = MENU_CAM_SIZE
	
	await get_tree().create_timer(1.0).timeout
	game_started = false

func _input(event: InputEvent) -> void:
	if !game_started && event is InputEventKey:
		game_started = true
		menu_to_game()
		
