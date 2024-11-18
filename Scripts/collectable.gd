extends Node3D

signal collided

var raycast : RayCast3D 
var is_positioned : bool = false
var object_heigth : float = 2.3
var tween : Tween
var model : Node3D

func _ready() -> void:
	hide()
	raycast = $RayCast_Distance
	raycast.enabled = true
	
	model = $Fruit
	tween = create_tween().set_loops()
	tween.TRANS_LINEAR
	tween.tween_property(model, "rotation_degrees", Vector3(0, 360, 0), 3.0).as_relative()

func start_position(max_z : float, max_x : float) -> void:
	position.z = randf_range(max_z, -max_z)
	position.x = randf_range(max_x, -max_x)
		
	
func _process(delta: float) -> void:
	if !is_positioned:
		check_heigth()
		pass
		
	

func check_heigth() -> void:

	if raycast.is_colliding():
		position.y = raycast.get_collision_point().y + object_heigth
		is_positioned = true
		show()
		print("colision detectada")
	else:
		print("no colision")
	print("altura ", position.y)
	

func _on_collision_detection_area_entered(area: Area3D) -> void:
	emit_signal("collided")
	queue_free()
