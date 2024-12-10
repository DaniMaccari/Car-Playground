extends Node3D

signal catched_signal
signal activate_fruit

@export var collectable_scene : PackedScene
@export var points_manager : Control
var max_z : int
var max_x : int

# spawn objects
var cone_object : PackedScene

func _ready() -> void:
	max_z = $MarkerZ.position.z
	max_x = $MarkerX.position.x
	
	cone_object = preload("res://Scenes/Particles/Cone.tscn")

func spawn_collectable() -> void:
	await get_tree().create_timer(0.2).timeout
	
	var collectable_actual := collectable_scene.instantiate()
	collectable_actual.select_fruit(points_manager.get_score()) #DEBUG
	
	self.add_child(collectable_actual)
	collectable_actual.start_position(max_z, max_x)
	collectable_actual.collided.connect(_on_collectable_collided)

func _on_collectable_collided(num_fruit: int, pos: Vector3) -> void:
	emit_signal("activate_fruit", num_fruit, pos)
	emit_signal("catched_signal")
	spawn_collectable()
	pass

func clear_collectable() -> void:
	for child in get_children():
		if child.is_in_group("fruit"):
			child.queue_free()

func spawn_cone(pos : Vector3) -> void:
	var new_cone := cone_object.instantiate()
	
	self.add_child(new_cone)
	new_cone.position = pos
