extends Node3D

@onready var points_manager := $PointsCounter
@onready var ui_manager := $Control

func _ready() -> void:
	get_tree().paused = true
	points_manager.catched_signal.connect(ui_manager.add_point)
	ui_manager.start_signal.connect(start_game)

func start_game() -> void:
	get_tree().paused = false
	points_manager.spawn_collectable()
	pass
