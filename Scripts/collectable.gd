extends Node3D

signal collided
@export var particles : PackedScene

var rng : RandomNumberGenerator
var raycast : RayCast3D 
var is_positioned : bool = false
var object_heigth : float = 2.3
var tween : Tween
var model : Node3D

var fruit_selected : int
@export var total_fruits : int = 0
const CHILLY_NUM : int = 3

#const max_z : int = 25
#const max_x : int = 25

func _ready() -> void:
	hide()
	raycast = $RayCast_Distance
	raycast.enabled = true
	
	model = $Fruit
	tween = create_tween().set_loops()
	tween.TRANS_LINEAR
	tween.tween_property(model, "rotation_degrees", Vector3(0, 360, 0), 3.0).as_relative()
	#rng = RandomNumberGenerator.new()
	#rng.randomize()

func select_fruit(fruit_num : int, max_z : float, max_x : float) -> void:
	
	var max_fruit : int = fruit_num / 10
	
	if max_fruit >= total_fruits:
		max_fruit = total_fruits
	
	if fruit_num % 10 == 0:
		fruit_selected = max_fruit
	else:
		fruit_selected = randi_range(0, max_fruit)
		
	#fruit_selected = randi_range(0, total_fruits)
	#fruit_selected = 5
	$Fruit.get_child(fruit_selected).show()
	print("fruit selected")
	#start_position(25.0, 25.0)
	
func start_position(max_z : float, max_x : float) -> void:
	position.z = randf_range(max_z, -max_z)
	position.x = randf_range(max_x, -max_x)
	pass
		
	
func _process(delta: float) -> void:
	if !is_positioned:
		check_heigth()
		pass

func check_heigth() -> void:
	
	if raycast.is_colliding():
		var collider := raycast.get_collider()
		if collider.is_in_group("floor") || collider.is_in_group("ramp"):
			is_positioned = true
			position.y = raycast.get_collision_point().y + object_heigth
			show()
			print("colision detectada")
	else:
		await get_tree().create_timer(1.0).timeout
		position.z = 0
		position.x = 0
		print("no colision")
	print("is_positioned ", is_positioned)
	print("posicion ", position)
	

func _on_collision_detection_area_entered(area: Area3D) -> void:
	emit_signal("collided", get_fruit(), global_position)
	var instance_particles := particles.instantiate()
	get_parent().add_child(instance_particles)
	instance_particles.global_position = global_position
	queue_free()

func get_fruit() -> int:
	return fruit_selected
