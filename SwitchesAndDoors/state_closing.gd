extends DoorState


func on_enter():
	door.open_d.connect(on_open_door)
	$"../../AntiCrushArea".body_entered.connect(on_body_entered_doorway)


func on_exit():
	door.open_d.disconnect(on_open_door)
	$"../../AntiCrushArea".body_entered.disconnect(on_body_entered_doorway)
	door.door_tween.finished.disconnect(on_tween_finished)


func on_tween_finished():
	if machine.current_state != self:
		return
	machine.set_state("StateClosed")


func on_open_door():
	if machine.current_state != self:
		return
	machine.set_state("StateOpening")
	door.tween_door_to_offset()


func on_body_entered_doorway(body):
	if machine.current_state != self:
		return
	if not body.is_in_group("uncrushables"):
		return
	machine.set_state("StateRevFromClosing")
	door.tween_door_to_offset()
