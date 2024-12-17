extends AudioStreamPlayer

@export var collect_sounds : Array[AudioStream]

@export var base_pitch : float = 0.6
var current_pitch : float = base_pitch
var collected_counter : int = 0
@onready var current_stream_index : int = 0



func play_collect_sound() -> void:
	collected_counter += 1
	current_pitch += 0.05
	if collected_counter >= 10:
		collected_counter = 0
		current_pitch = base_pitch
		stream = collect_sounds[-1]
	else:
		stream = collect_sounds[collected_counter/2]
	
	pitch_scale = current_pitch
	play()
	
	#current_pitch += 0.1
	#if(current_pitch > 1.2):
		#current_pitch = 0.9
		#current_stream_index += 1
		#current_stream_index %= collect_sounds.size()
		
	#stream = collect_sounds[current_stream_index]
	
	
