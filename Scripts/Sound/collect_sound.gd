extends AudioStreamPlayer

@export var collect_sounds_array : Array[AudioStream]
#@export var collect_sounds : Array[AudioStream]

@export var base_pitch : float = 1.0
var collected_counter : int = 0
var current_pitch : float = base_pitch
@onready var current_stream_index : int = 0

func restart_points() -> void:
	collected_counter = 0
	current_pitch = base_pitch

func play_collect_sound() -> void:
	collected_counter += 1
	#current_pitch += 0.05
	if collected_counter >= 10:
		collected_counter = 0
		#current_pitch = base_pitch
		stream = collect_sounds_array[0]
	else:
		print(collected_counter)
		if collected_counter < collect_sounds_array.size():
			stream = collect_sounds_array[collected_counter]
	
	pitch_scale = current_pitch
	play()
	
	#current_pitch += 0.1
	#if(current_pitch > 1.2):
		#current_pitch = 0.9
		#current_stream_index += 1
		#current_stream_index %= collect_sounds.size()
		
	#stream = collect_sounds[current_stream_index]
	
	
