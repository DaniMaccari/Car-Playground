extends StaticBody3D

@export var tree_models_array : Array[Node3D]
var tree_selected : int = 0

func _ready() -> void:
	
	for model in $TreeModel.get_children():
		model.hide()
	
	$TreeModel.get_child(randi_range(0, $TreeModel.get_children().size()-1)).show()
	$TreeModel.rotate_y(randi_range(0, 360)) 

func shake_tree() -> void:
	print("Shake Tree")
