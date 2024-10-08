extends DoorState # State Closing

func on_enter():
	door.stopped_moving_at_origin.connect(on_stopped_moving)
	door.should_open.connect(on_open_door)
	$"../../AntiCrushArea".body_entered.connect(on_body_entered_doorway)
	
	if door.area_has_uncrushables():
		machine.set_state("DoorStateRevFromClosing")
		return
	else:
		door.tween_door_to_origin()

func on_process(_delta: float):
	pass

func on_exit():
	call_deferred("_disconnect_signals")

func _disconnect_signals() -> void:
	door.stopped_moving_at_origin.disconnect(on_stopped_moving)
	door.should_open.disconnect(on_open_door)
	$"../../AntiCrushArea".body_entered.disconnect(on_body_entered_doorway)

func on_stopped_moving():
	machine.set_state("DoorStateClosed")

func on_open_door():
	machine.set_state("DoorStateOpening")

func on_body_entered_doorway(body):
	if not body.is_in_group("uncrushables"):
		return
	machine.set_state("DoorStateRevFromClosing")
