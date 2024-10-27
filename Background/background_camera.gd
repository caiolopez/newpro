extends Camera3D

const DEFAULT_FOV = 75.0
const RETURN_SPEED = 1  # Time in seconds to return to default

func _ready() -> void:
	AudioManager.bass_current_value.connect(func(value): 
		h_offset = value
		print(value)
	)
