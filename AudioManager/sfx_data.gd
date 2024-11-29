class_name SFXData
extends Resource

@export var sound: AudioStream ## Only in use if the sounds array is empty
@export var sounds: Array[AudioStream] = [] ## Array of all the sounds tied to this SFXData resource, allows randomization and sequential playback
@export_enum("Sequence", "Random") var playback_mode: int
@export var pausable: bool = false

@export_group("Pitch")
@export var randomize_pitch_scale: bool = false
@export var pitch_scale_min: float = 1.0
@export var pitch_scale_max: float = 1.0

var current_sequence_position: int = 0
var number_of_sounds: int = 0


func pick_sound() -> AudioStream:
	number_of_sounds = sounds.size()

	if playback_mode == 0 && number_of_sounds > 0:
		var sequenced_sound: AudioStream = sounds[current_sequence_position]
		current_sequence_position = wrapi(current_sequence_position + 1, 0, number_of_sounds - 1)
		return sequenced_sound
	elif playback_mode == 1 && number_of_sounds > 0:
		return sounds[randi_range(0, number_of_sounds - 1)]
	else:
		return sound


func pick_pitch_scale() -> float:
	if randomize_pitch_scale:
		return randf_range(pitch_scale_min, pitch_scale_max)
	else:
		return 1.0
