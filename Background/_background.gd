class_name _Background extends Node

@export var _monitor_entity_died: bool = false
@export var _monitor_entity_suffer: bool = false
@export var _monitor_entity_resurrect: bool = false
@export var _monitor_entity_regenerated: bool = false
@export var _monitor_entity_shot: bool = false
@export var _monitor_boss_changed_state: bool = false
@export var _monitor_hero_died: bool = false
@export var _monitor_hero_reached_checkpoint: bool = false
@export var _monitor_hero_started_tweening_to_respawn: bool = false
@export var _monitor_hero_respawned_at_checkpoint: bool = false

func _ready() -> void:
	if _monitor_entity_died:
		Events.entity_died.connect(_on_entity_died)
	if _monitor_entity_suffer:
		Events.entity_suffered.connect( _on_entity_suffered)
	if _monitor_entity_resurrect:
		Events.entity_restored.connect(_on_entity_restored)
	if _monitor_entity_regenerated:
		Events.entity_regenerated.connect(_on_entity_regenerated)
	if _monitor_entity_shot:
		Events.entity_shot.connect(_on_entity_shot)
	if _monitor_boss_changed_state:
		Events.boss_changed_stage.connect(_on_boss_changed_stage)
	if _monitor_hero_died:
		Events.hero_died.connect(_on_hero_died)
	if _monitor_hero_reached_checkpoint:
		Events.hero_reached_checkpoint.connect(_on_hero_reached_checkpoint)
	if _monitor_hero_started_tweening_to_respawn:
		Events.hero_started_tweening_to_respawn.connect(_on_hero_started_tweening_to_respawn)
	if _monitor_hero_respawned_at_checkpoint:
		Events.hero_respawned_at_checkpoint.connect(_on_hero_respawned_at_checkpoint)

func _on_entity_died(_entity: Node):
	pass

func _on_entity_suffered(_entity: Node):
	pass

func _on_entity_restored(_entity: Node):
	pass

func _on_entity_regenerated(_entity: Node):
	pass

func _on_entity_shot(_entity: Node):
	pass

func _on_boss_changed_stage(_entity: Node):
	pass

func _on_hero_died():
	pass

func _on_hero_reached_checkpoint():
	pass

func _on_hero_started_tweening_to_respawn():
	pass

func _on_hero_respawned_at_checkpoint():
	pass
