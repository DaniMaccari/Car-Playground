extends StaticBody3D

@export var tree_models_array : Array[Node3D]
var tree_selected : int = 0

func _ready() -> void:
	for model in tree_models_array:
		model.hide()
	
	tree_models_array[tree_selected].show()
	

func shake_tree() -> void:
	print("Shake Tree")
