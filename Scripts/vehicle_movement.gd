extends VehicleBody3D

@export var player_index : int = 0
const STEER_SPEED : float = 1.5
const STEER_LIMIT : float = 0.4
@export var MAX_STEER : float = 0.9
@export var ENGINE_POWER : float = 500
#@export var MAX_ENGINE_POWER : float = 500
const BRAKE_STRENGTH : float = 4.0
const DOWN_FORCE : float = -2100.0
const MIN_MOVEMENT_SPEED : float = 1.0
const FRICTION_IMPULSE : float = 1.0

var previous_speed := linear_velocity.length()
var _steer_target := 0.0
var initial_min_speed : float = 10.0
var floor_raycast : RayCast3D 

var respawn_timer : Timer
var respawning : bool = false
var smoke_particles : GPUParticles3D
var smoke_timer : Timer

# chilly
var chilly_effect : bool = false
const CHILLY_POWER : float = 1.5
var fire_particles : GPUParticles3D
var chilly_timer : Timer
# carrot
var carrot_counter : int = 0
var carrot_timer : Timer
var carrot_jumps : int = 4
# banana
var banana_effect : int = 1
#eggplant
var in_mud : bool = false

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
	
	fire_particles = $FireParticles
	fire_particles.emitting = false
	chilly_timer = Timer.new()
	chilly_timer.wait_time = 4.0
	chilly_timer.one_shot = true
	chilly_timer.timeout.connect(_on_chilly_timeout)
	add_child(chilly_timer)
	
	carrot_timer = $carrot_timer
	pass
	
func _physics_process(delta: float) -> void:
	
	#var fwd_mps := (linear_velocity * transform.basis).x
	#engine_force = Input.get_axis("ui_decel", "ui_accel") * ENGINE_POWER
	
	var actual_speed := linear_velocity.length()
	var direction := global_transform.basis.z.dot(linear_velocity.normalized())
	
	# drastic speed change -> collision
	var speed_change := actual_speed - previous_speed
	if abs(speed_change) > 7.0:
		print("big collision")
		$ImpactSound.play()
		Input.vibrate_handheld(100)
		# activate smoke
		smoke_particles.emitting = true
		smoke_timer.start()
		Input.start_joy_vibration(0, 0.5, 1.0, 0.15)
	elif abs(speed_change) > 1.0: # For softer bumps
		print("small collision")
		#$ImpactSound.play()
		for joypad in Input.get_connected_joypads():
			Input.start_joy_vibration(joypad, 0.5, 0.1, 0.1)
	
	# stick to floor
	if floor_raycast.is_colliding():
		var collider := floor_raycast.get_collider()
		
		if collider.is_in_group("floor"):
			var surface_normal : Vector3 = floor_raycast.get_collision_normal()
			apply_force(surface_normal * DOWN_FORCE, Vector3(0, 0, 0))
	
	
	if chilly_effect:
		if actual_speed < initial_min_speed && not is_zero_approx(actual_speed):
			engine_force = ENGINE_POWER * CHILLY_POWER * 4.0
		else:
			engine_force = ENGINE_POWER * CHILLY_POWER
	
	# initial accel faster
	elif Input.is_action_pressed("ui_accel"):
		
		#print(int(actual_speed)) #DEBUG
		if actual_speed < initial_min_speed && not is_zero_approx(actual_speed):
			#print("Max accel") #DEBUG
			#print(Input.get_action_strength("ui_accel"))
			engine_force = Input.get_action_strength("ui_accel") * ENGINE_POWER * 4.0
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

	if in_mud:
		steering = move_toward(steering, 0, delta * 10)
	else:
		steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER * banana_effect, delta * 10)
	# tocando suelo
	if actual_speed > 14.0 && $WheelBackLeft.is_in_contact() && $WheelBackRight.is_in_contact() && abs(Input.get_axis("ui_right", "ui_left")) > 0.5:
		$Drift/DriftParticlesL.emitting = true
		$Drift/DriftParticlesR.emitting = true
	else:
		$Drift/DriftParticlesL.emitting = false
		$Drift/DriftParticlesR.emitting = false
	#print(actual_speed)
	#print("direction", direction)
	previous_speed = actual_speed
	
	# car fell-off
	if transform.origin.y < -7:
		respawn_car()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_respawn"):
		respawn_car()

func spawn_car() -> void:
	show()
	transform.origin = Vector3(0, -0.2, 0)
	transform.basis = Basis()
	previous_speed = 0.0
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

func respawn_car() -> void:
	print("respawn")
	transform.origin = Vector3(0, -0.2, 0)
	transform.basis = Basis()
	previous_speed = 0.0
	respawn_timer.start()
	get_tree().paused = true
	
func _on_respawn_timeout() -> void:
	# BUG - si el timer acaba cuando se ha acabado el
	# tiempo de juego, se tiene que quedar pausado
	get_tree().paused = false

func _on_smoke_timeout() -> void:
	smoke_particles.emitting = false
#func this_controller(input_action) -> bool:
	#return input_action is player_index

func _on_area_3d_area_entered(area: Area3D) -> void:
	var collider := area.get_parent().get_parent()
	if collider.is_in_group("mud"):
		print("MUD")
		in_mud = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	in_mud = false

func activate_carrot() -> void:
	$Ears.show()
	carrot_counter = carrot_jumps
	carrot_timer.start()
	
func _on_timer_carrot_timeout() -> void:
	carrot_counter -= 1
	floor_raycast.enabled = false
	apply_impulse(Vector3(0, 700, 0), Vector3.ZERO)
	floor_raycast.enabled = true
	
	if carrot_counter <= 0:
		carrot_timer.stop()
		$Ears.hide()

func activate_chilly() -> void:
	fire_particles.emitting = true
	chilly_effect = true
	chilly_timer.start()

func _on_chilly_timeout() -> void:
	fire_particles.emitting = false
	chilly_effect = false

func activate_banana() -> void:
	banana_effect = -1
	$Banana.show()

func _on_banana_timer_timeout() -> void:
	banana_effect = 1
	$Banana.hide()
