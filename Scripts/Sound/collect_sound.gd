extends AudioStreamPlayer

@export var collect_sounds : Array[AudioStream]

@onready var current_pitch : float = 0.9
@onready var current_stream_index : int = 0

func play_collect_sound() -> void:
	current_pitch += 0.1
	if(current_pitch > 1.2):
		current_pitch = 0.9
		current_stream_index += 1
		current_stream_index %= collect_sounds.size()
		
	stream = collect_sounds[current_stream_index]
	
	pitch_scale = current_pitch
	play()
	
	pass
