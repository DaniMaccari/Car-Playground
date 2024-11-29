extends VehicleBody3D

@export var player_index : int = 0
const STEER_SPEED : float = 1.5
const STEER_LIMIT : float = 0.4
@export var MAX_STEER : float = 0.9
@export var ENGINE_POWER : float = 300
#@export var MAX_ENGINE_POWER : float = 500
const BRAKE_STRENGTH : float = 3.0
const DOWN_FORCE : float = -2100.0
const MIN_MOVEMENT_SPEED : float = 1.0
const FRICTION_IMPULSE : float = 1.0

var previous_speed := linear_velocity.length()
var _steer_target := 0.0
var initial_min_speed : float = 5.0
var floor_raycast : RayCast3D 

var respawn_timer : Timer
var respawning : bool = false
var smoke_particles : GPUParticles3D
var smoke_timer : Timer

func _ready() -> void:
	floor_raycast = $raycast_floor
	floor_raycast.enabled = true
	
	# set timer
	respawn_timer = Timer.new()
	respawn_timer.wait_time = 1.0
	respawn_timer.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	respawn_timer.one_shot = true
	respawn_timer.timeout.connect(_on_respawn_timeout)
	add_child(respawn_timer)
	
	# set particles
	smoke_particles = $SmokeParticles
	smoke_particles.emitting = false
	
	smoke_timer = Timer.new()
	smoke_timer.wait_time = 8.0
	smoke_timer.one_shot = true
	smoke_timer.timeout.connect(_on_smoke_timeout)
	add_child(smoke_timer)
	pass
	
func _physics_process(delta: float) -> void:
	
	#var fwd_mps := (linear_velocity * transform.basis).x
	#engine_force = Input.get_axis("ui_decel", "ui_accel") * ENGINE_POWER
	
	var actual_speed := linear_velocity.length()
	var direction := global_transform.basis.z.dot(linear_velocity.normalized())
	
	# drastic speed change -> collision
	if abs(actual_speed - previous_speed) > 3.0:
		print("big collision")
		Input.vibrate_handheld(100)
		
		# activate smoke
		smoke_particles.emitting = true
		smoke_timer.start()
		for joypad in Input.get_connected_joypads():
			Input.start_joy_vibration(joypad, 0.0, 0.6, 0.1)
	elif abs(actual_speed - previous_speed) > 1.0: # For softer bumps
		print("small collision")
		for joypad in Input.get_connected_joypads():
			Input.start_joy_vibration(joypad, 0.5, 0.0, 0.1)
	
	# stick to floor
	if floor_raycast.is_colliding():
		var collider := floor_raycast.get_collider()
		
		if collider.is_in_group("floor"):
			var surface_normal : Vector3 = floor_raycast.get_collision_normal()
			apply_force(surface_normal * DOWN_FORCE, Vector3(0, 0, 0))
	
	# initial accel faster
	if Input.is_action_pressed("ui_accel"):
		
		#print(int(actual_speed)) #DEBUG
		if actual_speed < initial_min_speed && not is_zero_approx(actual_speed):
			#print("Max accel") #DEBUG
			#print(Input.get_action_strength("ui_accel"))
			engine_force = Input.get_action_strength("ui_accel") * ENGINE_POWER * 2.5
		else:
			engine_force = Input.get_action_strength("ui_accel") * ENGINE_POWER
	
	elif Input.is_action_pressed("ui_decel"):

		if direction > 0.0:
			engine_force = -Input.get_action_strength("ui_decel") * ENGINE_POWER * BRAKE_STRENGTH
		elif actual_speed < initial_min_speed && not is_zero_approx(actual_speed):
			engine_force = -Input.get_action_strength("ui_decel") * ENGINE_POWER * 2.0
		else:
			engine_force = -Input.get_action_strength("ui_decel") * ENGINE_POWER
	
	else:
		engine_force = 0.0

	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
	
	#print("direction", direction)
	previous_speed = actual_speed
	
	# car fell-off
	if transform.origin.y < -7:
		respawn_car()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_respawn"):
		respawn_car()

func respawn_car() -> void:
	print("respawn")
	transform.origin = Vector3.ZERO
	transform.basis = Basis()
	previous_speed = 0.0
	respawn_timer.start()
	get_tree().paused = true
	
func _on_respawn_timeout() -> void:
	get_tree().paused = false

func _on_smoke_timeout() -> void:
	smoke_particles.emitting = false
#func this_controller(input_action) -> bool:
	#return input_action is player_index
