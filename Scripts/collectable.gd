extends Node3D

signal collided

var rng : RandomNumberGenerator
var raycast : RayCast3D 
var is_positioned : bool = false
var object_heigth : float = 2.3
var tween : Tween
var model : Node3D

var fruit_selected : int
@export var total_fruits : int = 0
const CHILLY_NUM : int = 3

func _ready() -> void:
	hide()
	raycast = $RayCast_Distance
	raycast.enabled = true
	
	model = $Fruit
	tween = create_tween().set_loops()
	tween.TRANS_LINEAR
	tween.tween_property(model, "rotation_degrees", Vector3(0, 360, 0), 3.0).as_relative()
	rng = RandomNumberGenerator.new()
	rng.randomize()

func select_fruit(fruit_num : int) -> void:
	var max_fruit : int = fruit_num / 10
	print(max_fruit)
	
	if max_fruit >= total_fruits:
		max_fruit = total_fruits
	
	
	
	fruit_selected = randi_range(0, max_fruit)
	#fruit_selected = randi_range(0, total_fruits)
	#fruit_selected = 5
	$Fruit.get_child(fruit_selected).show()
	pass
	
func start_position(max_z : float, max_x : float) -> void:
	position.z = rng.randf_range(max_z, -max_z)
	position.x = rng.randf_range(max_x, -max_x)
		
	
func _process(delta: float) -> void:
	if !is_positioned:
		check_heigth()
		pass
		
	

func check_heigth() -> void:

	if raycast.is_colliding():
		var collider := raycast.get_collider()
		if collider.is_in_group("floor"):
			position.y = raycast.get_collision_point().y + object_heigth
			is_positioned = true
			show()
			print("colision detectada")
	else:
		position.z = 0
		position.x = 0
		print("no colision")
	print("posicion ", position)
	

func _on_collision_detection_area_entered(area: Area3D) -> void:
	emit_signal("collided", get_fruit(), global_position)
	queue_free()

func get_fruit() -> int:
	return fruit_selected
