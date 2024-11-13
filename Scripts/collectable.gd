extends Node3D

signal collided

@export var raycast : RayCast3D

func _ready() -> void:
	pass

func start_position(max_z : float, max_x : float) -> void:
	position.z = randf_range(max_z, -max_z)
	position.x = randf_range(max_x, -max_x)
	
	raycast.enabled = true
	if raycast.is_colliding():
		print(raycast.get_collision_point().y)
		print("colision detectada")
	else:
		print("no colision")
	print("altura ", position.y)


func _on_collision_detection_area_entered(area: Area3D) -> void:
	emit_signal("collided")
	queue_free()
