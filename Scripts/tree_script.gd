extends StaticBody3D

@export var tree_models_array : Array[Node3D]
var tree_selected : int = 0

func _ready() -> void:
	
	for model in $TreeModel.get_children():
		model.hide()
	
	$TreeModel.get_child(randi_range(0, 4)).show()
	#tree_models_array[tree_selected].show()
	

func shake_tree() -> void:
	print("Shake Tree")
