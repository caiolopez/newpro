class_name BreadCrumb extends AnimatedSprite2D

@onready var dmg_taker = $DmgTaker

func _ready() -> void:
	Events.hero_reached_checkpoint.connect(commit_status)
	
	if dmg_taker != null:
		dmg_taker.died.connect(_on_died)
		dmg_taker.suffered.connect(func(_hp): Utils.paint_white(true, self, 0.1))
		dmg_taker.resurrected.connect(_on_resurrected)

func _on_died() -> void:
	animation = &"interacted"

func _on_resurrected() -> void:
	animation = &"default"
	
func set_as_interacted() -> void:
	animation = &"interacted"
	_geld_entity()

func commit_status() -> void:
	if dmg_taker.current_hp == 0 and dmg_taker.is_foe:
		SaveManager.log_entity_change(self, "interacted")
		_geld_entity()

func _geld_entity() -> void:
	if Events.hero_reached_checkpoint.is_connected(commit_status):
		Events.hero_reached_checkpoint.disconnect(commit_status)
	if dmg_taker.died.is_connected(_on_died):
		dmg_taker.died.disconnect(_on_died)
	if dmg_taker.resurrected.is_connected(_on_resurrected):
		dmg_taker.resurrected.disconnect(_on_resurrected)
	dmg_taker.set_deferred("disabled", true)
