class_name AudioEmiter extends Node2D

## Adds environmental 2D positional sound. Source of the sound is static.

@export var sfx_name: StringName = "" ## The sound emitted by this source, as named in the AudioManager.SFX dictionary.
@export var max_distance: float = 1000.0 ## The distance at which the sound becomes inaudible.
@export_group("Optionals")
@export var activation_area: Area2D = null ## Optional. The reference for an Area2D that activates this audio emiter upon overlap with hero. If empty, sound source will be always active.
@export var deactivate_upon_leaving_activation_area: bool = false ## If set to true, leaving the activation area will deactivate source.
var currently_active: bool = true
var camera: Camera2D = null

func _ready():
	if activation_area:
		currently_active = false
		activation_area.body_entered.connect(func(body):
			if body is Hero:
				_activate()
			)
		if deactivate_upon_leaving_activation_area:
			activation_area.body_exited.connect(func(body):
				if body is Hero:
					_deactivate()
				)
	else:
		_activate()

func _activate():
	currently_active = true
	AudioManager.play_positional_sfx(sfx_name, global_position, max_distance)

func _deactivate():
	currently_active = false
	AudioManager.stop_sfx(sfx_name)
