extends VehicleBody3D

const STEER_SPEED : float = 1.5
const STEER_LIMIT : float = 0.4
@export var MAX_STEER : float = 0.9
@export var ENGINE_POWER : float = 300
const BRAKE_STRENGTH : float = 2.0

var previous_speed := linear_velocity.length()
var _steer_target := 0.0

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("ui_decel", "ui_accel") * ENGINE_POWER
	
	var actual_lin_vel := linear_velocity.length()
	
	if abs(actual_lin_vel - previous_speed) > 3.0:
		
		# Sudden velocity change, likely due to a collision. Play an impact sound to give audible feedback,
		# and vibrate for haptic feedback.
		print("collision")
		Input.vibrate_handheld(100)
		for joypad in Input.get_connected_joypads():
			Input.start_joy_vibration(joypad, 0.0, 0.5, 0.1)
	
	if abs(actual_lin_vel - previous_speed) > 1.0: # For softer bumps
		for joypad in Input.get_connected_joypads():
			Input.start_joy_vibration(joypad, 0.5, 0.0, 0.1)
	
	previous_speed = actual_lin_vel
