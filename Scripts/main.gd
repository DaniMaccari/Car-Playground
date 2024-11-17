extends Node3D

@onready var points_manager := $PointsCounter
@onready var ui_manager := $Control

func _ready() -> void:
	points_manager.catched_signal.connect(ui_manager.add_point)
	
