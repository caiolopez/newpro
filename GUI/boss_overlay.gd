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
	Events.boss_trigger_entered.connect(_setup_bar)
	Events.boss_trigger_entered.connect(func(_boss): _show_hp_bar())
	Events.hero_died.connect(_hide_hp_bar)

func _setup_bar(boss):
	current_boss = boss
	$HpBar.max_value = dt.HP_AMOUNT
	_update_bar()
	dt.died.connect(_hide_hp_bar)
	dt.suffered.connect(_update_bar_animated)
	dt.resurrected.connect(_update_bar)

func _show_hp_bar():
	_update_bar()
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

func _hide_hp_bar():
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
	
	if dt.died.is_connected(_hide_hp_bar):
		dt.died.disconnect(_hide_hp_bar)
	if dt.suffered.is_connected(_update_bar_animated):
		dt.suffered.disconnect(_update_bar_animated)
	if dt.resurrected.is_connected(_update_bar):
		dt.resurrected.disconnect(_update_bar)

func _update_bar():
	$HpBar.value = dt.current_hp

func _update_bar_animated(_hp):
	_update_bar()
	Utils.paint_white(true, $HpBar, 0.1)
	var tween = create_tween()
	tween.tween_property(
		$HpBar,
		"position",
		Vector2($HpBar.position.x, 100),
		0.2).from(Vector2($HpBar.position.x, 90)).set_trans(Tween.TransitionType.TRANS_BACK)
