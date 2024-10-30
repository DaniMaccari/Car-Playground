extends VehicleBody3D


@export var MAX_STEER : float = 0.9
@export var ENGINE_POWER : float = 300
const BRAKE_STRENGTH : float = 2.0

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("ui_decel", "ui_accel") * ENGINE_POWER
