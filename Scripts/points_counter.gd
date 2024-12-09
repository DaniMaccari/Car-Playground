extends Node3D

signal catched_signal
signal activate_fruit

@export var collectable_scene : PackedScene
var max_z : int
var max_x : int

func _ready() -> void:
	max_z = $MarkerZ.position.z
	max_x = $MarkerX.position.x

func spawn_collectable() -> void:
	await get_tree().create_timer(0.2).timeout
	
	var collectable_actual := collectable_scene.instantiate()
	collectable_actual.select_fruit(100) #DEBUG
	
	self.add_child(collectable_actual)
	collectable_actual.start_position(max_z, max_x)
	collectable_actual.collided.connect(_on_collectable_collided)

func _on_collectable_collided(num_fruit: int) -> void:
	emit_signal("activate_fruit", num_fruit)
	emit_signal("catched_signal")
	spawn_collectable()
	pass

func clear_collectable() -> void:
	for child in get_children():
		if child.is_in_group("fruit"):
			child.queue_free()
