extends DoorState


func on_enter():
	door.close_d.connect(on_close_door)
	$"../../AntiCrushArea".body_entered.connect(on_body_entered_doorway)


func on_exit():
	door.close_d.disconnect(on_close_door)
	$"../../AntiCrushArea".body_entered.disconnect(on_body_entered_doorway)
	door.door_tween.finished.disconnect(on_tween_finished)

func on_tween_finished():
	if machine.current_state != self:
		return
	if door.auto_close_time <= 0:
		machine.set_state("StateOpen")
	else:
		machine.set_state("StateTemporarilyOpen")


func on_close_door():
	if machine.current_state != self:
		return
	machine.set_state("StateClosing")
	door.tween_door_to_origin()


func on_body_entered_doorway(body):
	if machine.current_state != self:
		return
	if not body.is_in_group("uncrushables"):
		return
	machine.set_state("StateRevFromOpening")
	door.tween_door_to_origin()
