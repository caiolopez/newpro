class_name BossOverlay extends Control

var current_boss: Node
var dt: DmgTaker:
	get:
		if current_boss:
			return current_boss.get_node("DmgTaker")
		else:
			return null

func _ready():
	hide()
	Events.boss_trigger_entered.connect(setup_bar)
	Events.boss_trigger_entered.connect(func(_boss): show_hp_bar())
	Events.hero_died.connect(hide_hp_bar)

func setup_bar(boss):
	print("SETUP BARRRRRRRRR")
	current_boss = boss
	$HpBar.max_value = dt.HP_AMOUNT
	update_bar()
	dt.died.connect(hide_hp_bar)
	dt.suffered.connect(update_bar_animated)
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
	if not visible: return
	var tween = create_tween()
	tween.tween_property(
		$HpBar,
		"position",
		Vector2($HpBar.position.x, -100),
		1)\
		.set_trans(Tween.TransitionType.TRANS_QUAD)\
		.set_ease(Tween.EaseType.EASE_IN_OUT)
	tween.tween_callback(hide)
	
	if dt.died.is_connected(hide_hp_bar):
		dt.died.disconnect(hide_hp_bar)
	if dt.suffered.is_connected(update_bar_animated):
		dt.suffered.disconnect(update_bar_animated)
	if dt.resurrected.is_connected(update_bar):
		dt.resurrected.disconnect(update_bar)

func update_bar():
	$HpBar.value = dt.current_hp

func update_bar_animated(_hp):
	update_bar()
	Utils.paint_white(true, $HpBar, 0.1)
	var tween = create_tween()
	tween.tween_property(
		$HpBar,
		"position",
		Vector2($HpBar.position.x, 100),
		0.2).from(Vector2($HpBar.position.x, 90)).set_trans(Tween.TransitionType.TRANS_BACK)
