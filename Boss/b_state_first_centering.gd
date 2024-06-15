extends BossState

var tween: Tween

func on_enter():
	var duration: float = 3.0
	tween = create_tween()
	tween.tween_property(
		boss,
		"global_position",
		$"../../Marker2D".global_position,
		duration).set_trans(Tween.TransitionType.TRANS_QUAD)
	tween.tween_callback(func(): machine.set_state("BStateChasing"))


func on_process(_delta: float):
	pass


func on_physics_process(_delta: float):
	pass


func on_exit():
	pass
