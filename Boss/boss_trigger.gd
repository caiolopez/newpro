extends Area2D

@export var boss: Node
@export var doors_to_close: Array[Door] = [] ## Optional list of simple doors to close upon reaching trigger.
@export var switch_group_to_close: SwitchGroupController = null ## Optional SwitchGroupController to close upon triggering.
@export_group("Optionals") ## Music and BG can also be set using entity components.
@export var background: StringName = ""
@export var track: StringName = ""


var is_active: bool = false

func _ready():
	body_entered.connect(func(body):
		if is_active:
			return
		if not body is Hero and not body.state_machine.current_state.death_prone:
			return
 
		if boss and boss != null:
			Events.boss_trigger_entered.emit(boss)
			_close_doors()
			_close_switch_group()
			is_active = true
			if background: BackgroundManager.change_background(background)
			if track: AudioManager.play_music(track)
		)

	Events.hero_respawned_at_checkpoint.connect(func():
		is_active = false
		)

func _close_doors():
	for d in doors_to_close:
		d.close()

func _close_switch_group():
	if switch_group_to_close:
		switch_group_to_close.close_whole_group()
