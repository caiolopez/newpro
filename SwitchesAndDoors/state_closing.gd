extends DoorState


func on_enter():
	if door.area_has_uncrushables():
		machine.set_state("StateOpening")
		return
	else:
		door.tween_door_to_origin()
	door.stopped_moving_at_origin.connect(on_stopped_moving)
	door.should_open.connect(on_open_door)
	$"../../AntiCrushArea".body_entered.connect(on_body_entered_doorway)


func on_exit():
	door.stopped_moving_at_origin.disconnect(on_stopped_moving)
	door.should_open.disconnect(on_open_door)
	$"../../AntiCrushArea".body_entered.disconnect(on_body_entered_doorway)


func on_stopped_moving():
	machine.set_state("StateClosed")


func on_open_door():
	machine.set_state("StateOpening")


func on_body_entered_doorway(body):
	if not body.is_in_group("uncrushables"):
		return
	machine.set_state("StateRevFromClosing")
