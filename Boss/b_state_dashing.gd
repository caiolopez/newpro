extends BossState


func on_enter():
	var duration: float = 3.0
	var tween = create_tween()
	tween.tween_property(
		boss,
		"global_position",
		Utils.get_hero_glpos(),
		duration).set_trans(Tween.TransitionType.TRANS_QUAD)
	tween.tween_callback(func():
		machine.set_state("BStatePostDash")
		tween.kill()
		)


func on_process(_delta: float):
	pass


func on_physics_process(_delta: float):
	pass


func on_exit():
	Events.camera_shake.emit()
