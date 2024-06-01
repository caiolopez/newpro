class_name Switch extends Area2D

enum SwitchState {
	ON,
	OFF,
	TEMP_ON
}

@export var toggle: bool = false ## Default switches (toggle == false) can only be switched on. Set this to true if this switch can be set to off as well.
var controller: Node2D
var current_state: SwitchState


func _ready():
	controller = get_parent()
	$TimerSimultWindow.set_wait_time(controller.simult_window_duration)
	$TimerSimultWindow.timeout.connect(on_simult_window_timeout)
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


func on_simult_window_timeout():
	switch_off()


func on_bullet_entered(area):
	if not area.is_in_group("bullets"):
		return
		
	match current_state:
		SwitchState.OFF:
			if controller.req_simultaneous:
				temporarily_switch_on()
			controller.on_switch_turned_on()
		SwitchState.ON:
			if toggle:
				controller.on_switch_turned_off()
		SwitchState.TEMP_ON:
			$TimerSimultWindow.start()
		
	area.kill_bullet()




