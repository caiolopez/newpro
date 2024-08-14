class_name Switch extends Area2D

@export var toggle: bool = false ## Default switches (toggle == false) can only be turned on. Set this to true if this switch can be turned off as well.
var controller: Node2D
var current_state: Constants.SwitchState
var last_processed_bullet: Bullet = null

func _ready():
	controller = get_parent()
	$TimerSimultWindow.set_wait_time(controller.simult_window_duration)
	$TimerSimultWindow.timeout.connect(on_simult_window_timeout)
	area_entered.connect(on_bullet_entered)
	area_exited.connect(func(area): if area == last_processed_bullet:
		last_processed_bullet = null, CONNECT_DEFERRED)
	switch_off()


func switch_on():
	current_state = Constants.SwitchState.ON
	$TimerSimultWindow.stop()
	modulate = Color(0, 1, 0)


func switch_off():
	current_state = Constants.SwitchState.OFF
	$TimerSimultWindow.stop()
	modulate = Color(1, 0, 0)


func temporarily_switch_on():
	current_state = Constants.SwitchState.TEMP_ON
	$TimerSimultWindow.start()
	modulate = Color(1, 1, 0)


func on_simult_window_timeout():
	switch_off()


func on_bullet_entered(area):
	if not area is Bullet: return
	if area == last_processed_bullet: return

	last_processed_bullet = area

	match current_state:
		Constants.SwitchState.OFF:
			if controller.req_simultaneous:
				temporarily_switch_on()
			controller.on_switch_turned_on()
		Constants.SwitchState.ON:
			if toggle:
				controller.on_switch_turned_off()
		Constants.SwitchState.TEMP_ON:
			$TimerSimultWindow.start()
		
	area.kill_bullet()

func on_bullet_exited(area):
	if area == last_processed_bullet:
		last_processed_bullet = null
