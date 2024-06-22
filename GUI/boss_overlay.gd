class_name BossOverlay extends Control

var current_boss: Node
var dt: DmgTaker:
	get: return current_boss.get_node("DmgTaker")

func _ready():
	hide()
	Events.boss_trigger_entered.connect(setup_bar, CONNECT_ONE_SHOT)
	Events.boss_trigger_entered.connect(func(_boss): show_hp_bar())
	Events.hero_died.connect(hide_hp_bar)

func setup_bar(boss):
	current_boss = boss
	$HpBar.max_value = dt.HP_AMOUNT
	update_bar()
	dt.died.connect(hide_hp_bar)
	dt.suffered.connect(func(_hp): update_bar_animated())
	dt.resurrected.connect(update_bar)

func show_hp_bar():
	update_bar()
	show()
	var tween = create_tween()
	tween.tween_property(
		$HpBar,
		"position",
		Vector2($HpBar.position.x, 100),
		2)\
		.set_trans(Tween.TransitionType.TRANS_BACK)\
		.set_ease(Tween.EaseType.EASE_OUT)\
		.set_delay(2)

func hide_hp_bar():
	var tween = create_tween()
	tween.tween_property(
		$HpBar,
		"position",
		Vector2($HpBar.position.x, -100),
		1)\
		.set_trans(Tween.TransitionType.TRANS_QUAD)\
		.set_ease(Tween.EaseType.EASE_IN_OUT)
	tween.tween_callback(hide)

func update_bar():
	$HpBar.value = dt.current_hp

func update_bar_animated():
	update_bar()
	Utils.paint_white(true, $HpBar, 0.1)
	var tween = create_tween()
	tween.tween_property(
		$HpBar,
		"position",
		Vector2($HpBar.position.x, 100),
		0.2).from(Vector2($HpBar.position.x, 90)).set_trans(Tween.TransitionType.TRANS_BACK)

