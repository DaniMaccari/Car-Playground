extends Node3D

signal collided

func _ready() -> void:
	pass

func start_position(max_z : float, max_x : float) -> void:
	position.z = randf_range(max_z, -max_z)
	position.x = randf_range(max_x, -max_x)


func _on_collision_detection_area_entered(area: Area3D) -> void:
	emit_signal("collided")
	queue_free()
