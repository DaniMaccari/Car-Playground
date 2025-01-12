extends StaticBody3D
var started : bool = false
var positioned : bool = false
var raycast : RayCast3D
var velocity : float = 4.0

func _ready() -> void:
	rotate_y(randi_range(0, 360))
	
	raycast = $RayCast3D
	raycast.enabled = true
	started = true
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started && not positioned:
		velocity += 10 * delta
		position.y -= velocity * delta
		check_heigth()

func check_heigth() -> void:
	if raycast.is_colliding():
		var collider := raycast.get_collider()
		if collider.is_in_group("floor") || collider.is_in_group("ramp"):
			positioned = true
			velocity = 0.0
