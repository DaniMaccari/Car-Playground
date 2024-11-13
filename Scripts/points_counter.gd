extends Node3D

@export var collectable_scene : PackedScene
var max_z : int
var max_x : int

func _ready() -> void:
	max_z = $MarkerZ.position.z
	max_x = $MarkerX.position.x
	spawn_collectable()
	pass # Replace with function body.

func spawn_collectable() -> void:
	var collectable_actual := collectable_scene.instantiate()
	collectable_actual.start_position(max_z, max_x)
	collectable_actual.collided.connect(_on_collectable_collided)
	add_child(collectable_actual)

func _on_collectable_collided() -> void:
	spawn_collectable()
	pass
	
	
