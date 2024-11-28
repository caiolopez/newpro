class_name BossOverlay extends Control

var current_boss: Node
var dt: DmgTaker:
	get:
		if current_boss:
			return current_boss.get_node("DmgTaker")
		else:
			return null
var _hp_bar_tween: Tween

func _ready():
	hide()
	Events.boss_trigger_entered.connect(_setup_bar)
	Events.boss_trigger_entered.connect(func(boss):
		_grab_boss_color(boss)
		_show_hp_bar()
		)
	Events.hero_died.connect(hide_hp_bar_instantly)
	Events.boss_changed_stage.connect(_grab_boss_color, CONNECT_DEFERRED)

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

	if _hp_bar_tween and _hp_bar_tween.is_valid():
		_hp_bar_tween.kill()

	_hp_bar_tween = create_tween()
	_hp_bar_tween.tween_property(
		$HpBar,
		"position",
		Vector2($HpBar.position.x, 100),
		2)\
		.set_trans(Tween.TransitionType.TRANS_BACK)\
		.set_ease(Tween.EaseType.EASE_OUT)\
		.set_delay(2)

func hide_hp_bar_instantly():
		_hide_hp_bar(true)

func _hide_hp_bar(instant: bool = false):
	if not visible: return

	if _hp_bar_tween and _hp_bar_tween.is_valid():
		_hp_bar_tween.kill()

	if instant:
		$HpBar.position.y = -100
		hide()
	else:
		_hp_bar_tween = create_tween()
		_hp_bar_tween.tween_property(
			$HpBar,
			"position",
			Vector2($HpBar.position.x, -100),
			1)\
			.set_trans(Tween.TransitionType.TRANS_QUAD)\
			.set_ease(Tween.EaseType.EASE_IN_OUT)
		_hp_bar_tween.tween_callback(hide)
	
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
	Utils.colorize_silhouette(true, $HpBar, 0.1)

	if _hp_bar_tween and _hp_bar_tween.is_valid():
		_hp_bar_tween.kill()

	_hp_bar_tween = create_tween()
	_hp_bar_tween.tween_property(
		$HpBar,
		"position",
		Vector2($HpBar.position.x, 100),
		0.2).from(Vector2($HpBar.position.x, 90)).set_trans(Tween.TransitionType.TRANS_BACK)

func _grab_boss_color(boss: Node):
	if boss.has_node("GfxController/BwShaderSetter"):
		var boss_current_color = boss.get_node("GfxController/BwShaderSetter").get_color()
		$BwShaderSetter.set_color_pair(boss_current_color)
