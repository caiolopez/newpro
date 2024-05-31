class_name Switch extends Area2D

enum SwitchState {
	ON,
	OFF,
	TEMP_ON
}

@export var req_simultaneous: bool = false ## Set this to true if all switches must be activated roughly at the same time.
@export var simult_window_duration: float = 0.1 ## The amount of time before a temporarily on switch gives up and shuts back off.
@export var toggle: bool = false ## Default switches (toggle == false) can only be switched on. Set this to true if this switch can be set to off as well.
var current_state: SwitchState
var related_switches: Array[Switch] = []
var related_doors: Array[Door] = []
var group_is_req: bool = false
var group_is_simult: bool = false


func _ready():
	check_group()
	Events.reached_checkpoint.connect(commit_status)
	Events.respawned_at_checkpoint.connect(reset_status)
	$TimerSimultWindow.timeout.connect(on_simult_window_timeout)
	$TimerSimultWindow.set_wait_time(simult_window_duration)
	area_entered.connect(on_bullet_entered)
	switch_off()


func switch_on():
	current_state = SwitchState.ON
	$TimerSimultWindow.stop()
	print(name, " STATE SET TO: ", current_state)
	modulate = Color(0, 1, 0)


func switch_off():
	current_state = SwitchState.OFF
	$TimerSimultWindow.stop()
	print(name, " STATE SET TO: ", current_state)
	modulate = Color(1, 0, 0)


func temporarily_switch_on():
	current_state = SwitchState.TEMP_ON
	$TimerSimultWindow.start()
	print(name, " STATE SET TO: ", current_state)
	modulate = Color(1, 1, 0)


func commit_status():
	pass


func reset_status():
	pass


func on_simult_window_timeout():
	switch_off()


func on_bullet_entered(area):
	if not area.is_in_group("bullets"):
		return
		
	match current_state:
		SwitchState.OFF:
			if group_is_simult:
				temporarily_switch_on()
				var all_are_temp_on: bool = true
				for sw in related_switches:
					if sw.current_state != SwitchState.TEMP_ON:
						all_are_temp_on = false
				if all_are_temp_on:
					for sw in related_switches:
						sw.switch_on()
			else:
				switch_on()
		SwitchState.ON:
			if toggle:
				switch_off()
		SwitchState.TEMP_ON:
			$TimerSimultWindow.start()
		
	area.kill_bullet()


func check_group():
	for sib in get_parent().get_children():
		if sib is Switch:
			related_switches.append(sib)
			if sib.req_simultaneous:
				group_is_simult = true
		if sib is Door:
			related_doors.append(sib)