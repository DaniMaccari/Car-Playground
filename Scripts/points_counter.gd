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
	await get_tree().create_timer(0.2).timeout
	
	var collectable_actual := collectable_scene.instantiate()
	
	get_parent().add_child(collectable_actual)
	collectable_actual.start_position(max_z, max_x)
	collectable_actual.collided.connect(_on_collectable_collided)

func _on_collectable_collided() -> void:
	spawn_collectable()
	pass
	
	