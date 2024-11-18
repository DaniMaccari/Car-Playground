extends Node3D

var camera_tween : Tween
var in_menu : bool
@onready var camera : Camera3D = $Camera3D

@onready var menu_ui := $menu_UI
@onready var points_manager := $PointsCounter
@onready var ui_manager := $ingame_UI

func _ready() -> void:
	print("ready game")
	in_menu = true
	menu_ui.visible = true
	ui_manager.visible = false
	camera.rotation_degrees = Vector3(-10, 0, 0)
	$VehicleBody3D.visible = false
	points_manager.catched_signal.connect(ui_manager.add_point)
	ui_manager.start_signal.connect(start_game)

func start_game() -> void:
	get_tree().paused = false
	$VehicleBody3D.visible = true
	points_manager.spawn_collectable()
	pass
	
func camera_transition() -> void:
	camera_tween = create_tween()
	camera_tween.set_trans(Tween.TRANS_LINEAR)
	camera_tween.tween_property(camera, "rotation_degrees", Vector3(-44, 0, 0), 0.6)
	camera_tween.tween_callback(start_ingameUI)

func menu_to_game() -> void:
	menu_ui.change_scene()
	camera_transition()

func start_ingameUI() -> void:
	ui_manager.delay_ready()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept"):
		menu_to_game()
		
