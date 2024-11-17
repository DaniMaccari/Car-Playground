extends Node3D



func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_respawn"):
		print("respawn")
		print($VehicleBody3D.transform.origin)
		#$VehicleBody3D.transform = Vector3.ZERO
		#transform.position = Vector3.ZERO
