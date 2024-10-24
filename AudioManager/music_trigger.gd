extends Area2D

@export_enum("nothing", "giorgio", "gorgo") var track: String

func _ready():
	body_entered.connect(func(body):
		if not body is Hero: return
		if not track or track == "nothing": AudioManager.stop_music()
		else: AudioManager.play_music(track)
		)
