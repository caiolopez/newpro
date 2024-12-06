class_name AudioEmitter extends Node2D

@export var sfx_name: StringName = "" ## The sound effect to be played, as named in AudioManager.SFX{}. Remember that looping is set directly on the import of the audio resource.
@export var max_distance: float = 1000.0 ## The distance after which the audio is inaudible.
@export var fixed_position: bool = true ## If true, once instantiated, the audio position will be fixed relative to the game level. Set it to false if the audio emitter is moving around, and leave as true if the emitter is static.
@export var volume_db: float = 0.0
@export var start_active: bool = true ## If true, will cause the audio to play automatically upon node entering tree.
@export_group("Optionals")
@export var activation_area: Area2D = null ## If present and valid, the audio emitter will only activate after this Area2D is overlapped by the hero. Leave empty if the sound should be active from the start.
@export var deactivate_upon_leaving_activation_area: bool = false ## If an Area2D activation area was supplied, setting this variable to true will cause leaving the area to deactivate the audio emitter.
var currently_active: bool = false

func _ready() -> void:
	if activation_area:
		activation_area.body_entered.connect(func(body):
			if body is Hero:
				activate()
			)
		if deactivate_upon_leaving_activation_area:
			activation_area.body_exited.connect(func(body):
				if body is Hero:
					deactivate()
				)
	
	for child in get_parent().get_children():
		if child is DmgTaker:
			child.died.connect(deactivate)
			child.restored.connect(activate)
			break

func _process(_delta: float) -> void:
	AudioManager.update_positional_sfx_position(self, self.global_position)

func _enter_tree():
	if start_active and not activation_area:
		activate()

func _exit_tree():
	deactivate()

func activate():
	if currently_active: return
	currently_active = true
	AudioManager.play_positional_sfx(sfx_name, global_position, self, max_distance, volume_db)

func deactivate():
	if not currently_active: return
	currently_active = false
	AudioManager.stop_specific_positional_sfx(self)
