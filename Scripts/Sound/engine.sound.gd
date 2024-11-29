extends Node3D

var car_speed : float
@export_range(0, 1) var maximum_volume : float

var maximum_db :float


var engines : Array[AudioStreamPlayer3D]

var speed_lerper : float
@onready var parent_vehicle := get_parent()

func logWithBase(value: float, base: float) -> float:
	return log(value) / log(base)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed_lerper = 0
	maximum_db = linear_to_db(maximum_volume)
	
	for N in get_node(".").get_children():
		engines.append(N)
	
	for engine in engines:
		engine.volume_db = -80
	start_engine_sound()

func start_engine_sound() -> void:
	for engine in engines:
		engine.play()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_get_speed_value(delta)
	update_engine_streams()
	pass

func _get_speed_value(delta: float) -> void:
	if Input.is_action_pressed("ui_accel"):
		speed_lerper += delta
	elif Input.is_action_pressed("ui_decel"):
		speed_lerper -= delta
	elif speed_lerper > 0.1 || speed_lerper < -0.1:
		speed_lerper -= delta
	
	speed_lerper = clamp(abs(speed_lerper), -1, 1)
	print(speed_lerper)
	car_speed = speed_lerper

func update_engine_streams() -> void:
	#if(car_speed <= 0.25):
		#var fade_1 : float = clamp(remap(car_speed, 0, 0.25, 0, 1), 0, 1)
		#crossfade(engine0, engine1, fade_1)
		#engine2.volume_db = -80
		#engine3.volume_db = -80
		#engine4.volume_db = -80
	#elif(car_speed <= 0.5):
		#var fade_2 : float = clamp(remap(car_speed, 0.25, 0.5, 0, 1), 0, 1)
		#crossfade(engine1, engine2, fade_2)
		#engine0.volume_db = -80
		#engine3.volume_db = -80
		#engine4.volume_db = -80
	#elif(car_speed <= 0.75):
		#var fade_3 : float = clamp(remap(car_speed, 0.5, 0.75, 0, 1), 0, 1)
		#crossfade(engine2, engine3, fade_3)
		#engine0.volume_db = -80
		#engine1.volume_db = -80
		#engine4.volume_db = -80
	#elif(car_speed <= 1):
		#var fade_4 : float = clamp(remap(car_speed, 0.75, 1, 0, 1), 0, 1)
		#crossfade(engine3, engine4, fade_4)
		#engine0.volume_db = -80
		#engine1.volume_db = -80
		#engine2.volume_db = -80
	#else:
		#engine0.volume_db = -80
		#engine1.volume_db = -80
		#engine2.volume_db = -80
		#engine3.volume_db = -80
		#engine4.volume_db = maximum_db
	#if(car_speed <= 0.1):	
		#for i in range (engines.size()):
			#if i != 0 || i != 1:
				#engines[i].volume_db = -80
			#var fade_1 : float = clamp(remap(car_speed, 0, 0.25, 0, 1), 0, 1)
			#crossfade(engines[0], engines[1], fade_1) 

	for i in range (engines.size() - 1):
		#if car speed is inside the possible lerp range
		if(car_speed > (i - 1) * 0.1 && car_speed < (i + 1) * 0.1):
			#loop all other engines and lower volume
			for j in range (engines.size()):
				if i != i || i != i + 1:
					engines[i].volume_db = -80
			#crossfade between the necessary audio streams
			var fade : float = clamp(remap(car_speed, (i - 1) * 0.1, (i + 1) * 0.1, 0, 1), 0, 1)
			crossfade(engines[i], engines[i+1], fade) 

func crossfade(as1: AudioStreamPlayer3D, as2: AudioStreamPlayer3D, t: float) -> void:
	var amplitudes: Vector2 = exp_fade(t, 1.5)
	var pitch := linear_fade(t)
	as1.pitch_scale = lerp(1., 1.25, pitch.y)
	as1.volume_db = linear_to_db(maximum_volume - amplitudes.y)
	as2.volume_db = linear_to_db(maximum_volume - amplitudes.x)

func linear_fade(u: float) -> Vector2:
	return Vector2(1-u, u)

func quadratic_out_fade (u:float) -> Vector2:
	u = u * u
	return Vector2(1-u, u)

func quadratic_in_fade(u:float) -> Vector2:
	u = 1-u
	u = u * u
	return Vector2(u, 1-u)

func log_fade(u:float) -> Vector2:
	u = clamp(logWithBase(u + 0.1, 10) + 1, 0, 1)
	return Vector2(1-u, u)
	
func exp_fade(u:float, p:float) -> Vector2:
	u = pow(u, p)
	return Vector2(1-u, u)
