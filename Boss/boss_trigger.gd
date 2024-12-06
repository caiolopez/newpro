extends Area2D

@export var boss: Node
@export var doors_to_close: Array[Door] = [] ## Optional list of simple doors to close upon reaching trigger.
@export var switch_group_to_close: SwitchGroupController = null ## Optional SwitchGroupController to close upon triggering.
@export_group("Optionals") ## Music and BG can also be set using entity components.
@export var background: StringName = ""
@export var track: StringName = ""
var is_active: bool = false

func _ready() -> void:
	body_entered.connect(func(body) -> void:
		if is_active: return
		if not body is Hero and not body.state_machine.current_state.death_prone:
			return
		call_deferred("_attempt_to_activate_boss")
		)

	Events.hero_respawned_at_checkpoint.connect(func() -> void:
		if not is_active: return
		is_active = false
		if AppManager.hero in get_overlapping_bodies()\
		and not AppManager.hero.state_machine.current_state.death_prone:
			call_deferred("_attempt_to_activate_boss")
		)

func _attempt_to_activate_boss() -> void:
	if boss and boss != null:
		Events.boss_trigger_entered.emit(boss)
		_close_doors()
		_close_switch_group()
		is_active = true
		if background: BackgroundManager.change_background(background)
		if track: AudioManager.play_music(track)

func _close_doors() -> void:
	for d in doors_to_close:
		d.close()

func _close_switch_group() -> void:
	if switch_group_to_close:
		switch_group_to_close.close_whole_group()
