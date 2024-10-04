class_name SwitchGroupController extends Node


@export var req_simultaneous: bool = false ## Set this to true if all switches must be activated at the same time.
@export_range(0.01, 60) var simult_window_duration: float = 0.1 ## The amount of time before a temporarily on switch gives up and shuts back off.
var related_switches: Array[Switch] = []
var related_doors: Array[Door] = []
var group_is_on: bool = false
var group_is_saved: bool = false


func _ready():
	check_group()
	Events.hero_reached_checkpoint.connect(commit_status)
	Events.hero_respawned_at_checkpoint.connect(reset_status)


func check_group():
	for sib in get_children():
		if sib is Switch:
			related_switches.append(sib)
		if sib is Door:
			related_doors.append(sib)


func commit_status():
	if group_is_on:
		group_is_saved = true
		SaveManager.log_entity_change(self, "on_and_saved")


func reset_status():
	if not group_is_saved:
		for sw in related_switches:
			sw.switch_off()
		for door in related_doors:
			door.insta_close()
	else:
		for sw in related_switches:
			sw.switch_on()
		for door in related_doors:
			door.insta_open()


func open_rel_doors():
	for door in related_doors:
		door.open()


func close_rel_doors():
	for door in related_doors:
		door.close()


func turn_on_rel_switches():
	for switch in related_switches:
		switch.switch_on()
		group_is_on = true


func turn_off_rel_switches():
	for switch in related_switches:
		switch.switch_off()
		group_is_on = false


func on_switch_turned_on():
	if req_simultaneous:
		var all_temp: bool = true
		for sw in related_switches:
			if sw.current_state != Constants.SwitchState.TEMP_ON:
				all_temp = false
		if all_temp:
			turn_on_rel_switches()
			open_rel_doors()
			group_is_on = true
	else:
		turn_on_rel_switches()
		open_rel_doors()
		group_is_on = true


func on_switch_turned_off():
	close_rel_doors()
	turn_off_rel_switches()
	group_is_on = false


func force_group_on_and_saved():
	for sw in related_switches:
		sw.switch_on()
	for door in related_doors:
		door.insta_open()
	group_is_on = true
	group_is_saved = true
