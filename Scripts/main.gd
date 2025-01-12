extends Node3D

var game_started : bool = false

var camera_tween : Tween
const MENU_CAM_DEG : Vector3 = Vector3(-15, 0, 0)
const INGAME_CAM_DEG : Vector3 = Vector3(-44, 0, 0)
const MENU_CAM_SIZE : int = 43
const  INGAME_CAM_SIZE : int = 58
@onready var car_player : VehicleBody3D = $VehicleBody3D
@onready var camera : Camera3D = $Camera3D

@onready var menu_ui := $menu_UI
@onready var points_manager := $PointsCounter
@onready var ui_manager := $ingame_UI
@onready var ui_end := $end_UI

@onready var water_position := $WaterMesh

func _ready() -> void:
	
	print("ready game")
	menu_ui.show()
	ui_manager.hide()
	ui_end.hide()
	camera.rotation_degrees = MENU_CAM_DEG
	car_player.visible = false
	points_manager.catched_signal.connect(ui_manager.add_point)
	points_manager.activate_fruit.connect(fruit_effect)
	ui_manager.start_signal.connect(start_game)
	ui_manager.end_signal.connect(end_game)

func start_game() -> void:
	get_tree().paused = false
	car_player.spawn_car()
	points_manager.spawn_collectable()

func menu_to_game() -> void:
	ui_end.change_scene()
	menu_ui.change_scene()
	
	points_manager.clear_collectable()
	camera_transition()
	$WaterMesh.show()
	$CollectSound.restart_points()

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
	
	await get_tree().create_timer(2.0).timeout
	
	$BackMusic.pitch_scale = 1
	$BackMusic.play()

func end_game() -> void:
	#$BackMusic.volume_db = -30
	$EndSound.play()
	$BackMusic.pitch_scale = 0.8
	
	camera.rotation_degrees = MENU_CAM_DEG
	camera.size = MENU_CAM_SIZE
	
	ui_end.set_score(ui_manager.get_score())
	
	await get_tree().create_timer(1.5).timeout
	game_started = false

func _input(event: InputEvent) -> void:
	if !game_started && (event is InputEventKey || event is InputEventJoypadButton):
		$ButtonSound.play() #SOUND
		
		ui_manager.hide()
		game_started = true
		menu_to_game()
		
		await get_tree().create_timer(1.1).timeout
		$StartSound.play() #SOUND
		
func fruit_effect(num_fruit : int, pos : Vector3) -> void:
	match num_fruit:
		0:
			print(num_fruit)
			points_manager.spawn_fence(pos)
		1:
			points_manager.spawn_cone(pos)
		2:
			car_player.activate_chilly()
		3:
			car_player.activate_carrot()
		4:
			car_player.activate_banana()
		#5:
			#points_manager.spawn_mud(pos)
	
