class_name SwitchGroupController extends Node


@export var req_simultaneous: bool = false ## Set this to true if all switches must be activated at the same time.
@export_range(0.01, 60) var simult_window_duration: float = 0.1 ## The amount of time before a temporarily on switch gives up and shuts back off.
@export var auto_off_time: float = 0.0 ## If bigger than zero, causes the sistem to automatically shut down after the specified time is up.
@onready var auto_off_timer: Timer = $AutoOffTimer
@onready var beep_timer: Timer = $BeepTimer
var related_switches: Array[Switch] = []
var related_doors: Array[Door] = []
var group_is_on: bool = false
var group_is_saved: bool = false
const INSTANTLY: bool = true

func _ready() -> void:
	_check_group()
	Events.hero_reached_checkpoint.connect(_commit_status)
	Events.hero_respawned_at_checkpoint.connect(_reset_status)

	if auto_off_time > 0:
		Events.hero_died.connect(func():
			_stop_auto_off()
			)
		auto_off_timer.timeout.connect(func():
			close_whole_group()
			)
		beep_timer.timeout.connect(func():
			AudioManager.hooks.timed_door_beep_sfx()
			)

func _check_group() -> void:
	for sib in get_children():
		if sib is Switch:
			related_switches.append(sib)
		if sib is Door:
			related_doors.append(sib)

func _commit_status() -> void:
	if auto_off_time > 0: return
	if group_is_on:
		group_is_saved = true
		SaveManager.log_entity_change(self, "on_and_saved")

func _reset_status() -> void:
	if not group_is_saved:
		close_whole_group(INSTANTLY)
	else:
		open_whole_group(INSTANTLY)

func _open_rel_doors() -> void:
	for door in related_doors:
		door.open()

func _close_rel_doors() -> void:
	for door in related_doors:
		door.close()

func _turn_on_rel_switches() -> void:
	for switch in related_switches:
		switch.switch_on()
		group_is_on = true
		_start_auto_off()

func _turn_off_rel_switches() -> void:
	for switch in related_switches:
		switch.switch_off()
		group_is_on = false
		_stop_auto_off()

func on_switch_turned_on() -> void:
	AudioManager.hooks.switch_on_sfx()
	if req_simultaneous:
		var all_temp: bool = true
		for sw in related_switches:
			if not sw.is_state_temp_on():
				all_temp = false
		if all_temp:
			_turn_on_rel_switches()
			_open_rel_doors()
			group_is_on = true
			_start_auto_off()
	else:
		_turn_on_rel_switches()
		_open_rel_doors()
		group_is_on = true
		_start_auto_off()

func on_switch_turned_off() -> void:
	AudioManager.hooks.switch_off_sfx()
	_close_rel_doors()
	_turn_off_rel_switches()
	group_is_on = false
	_stop_auto_off()

func force_group_on_and_saved() -> void:
	for sw in related_switches:
		sw.switch_on()
	for door in related_doors:
		door.insta_open()
	group_is_on = true
	_stop_auto_off()
	group_is_saved = true

func close_whole_group(instant: bool = false) -> void:
	for sw in related_switches:
		sw.switch_off()
	for door in related_doors:
		if instant: door.insta_close()
		else: door.close()
	_stop_auto_off()

func open_whole_group(instant: bool = false) -> void:
	for sw in related_switches:
		sw.switch_on()
	for door in related_doors:
		if instant: door.insta_open()
		else: door.open()

func _start_auto_off():
	if auto_off_time > 0:
		auto_off_timer.start(auto_off_time)
		beep_timer.start()

func _stop_auto_off():
	if auto_off_time > 0:
		auto_off_timer.stop()
		beep_timer.stop()
