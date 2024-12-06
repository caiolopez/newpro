class_name Effector extends Area2D

enum Effects {
	QUEUE_FREE, ## Deletes affected nodes forever.
	DISPLACE, ## Changes the global position of affected nodes, provided that they are Node2D.
	ENABLE, ## Disables all affected nodes upon start so that, when activated, the affected nodes are all enabled.
	RESET_BEHAVIOR, ## Calls reset_behavior() on all affected nodes, provided that they are within "resetables" group and have such method.
	SET_CURRENTLY_DEAD ## Stages affected entities for queue_free() on next hero_reached_checkpoint event. Can be reverted by hero death.
	}
@export var effect: Effects = Effects.QUEUE_FREE ## The effect that will happen to all children of this node, as well as to any node appended to the Entities Array.
@export var destination: Vector2 ## If set to displace entities, this is the global position they will be instantly moved to.
@export var entities: Array[Node] ## The entities that will be affected. Note: All children of Effector will automatically be included in this Array.
@export var send_to_save_manager: bool = true ## When set to true, logs the changes so that effects are reapplied upon reloading region. Note: only works for queue free and displace.
@export_category("Optional")
@export var use_this_trigger_area: Area2D = null ## When not empty, will activate upon body or area entering this area as well.

func _ready() -> void:
	_add_children_to_entities()
	if effect == Effects.ENABLE:
		_disable_entities()

	if not use_this_trigger_area:
		body_entered.connect(_on_body_entered)

	if use_this_trigger_area:
		use_this_trigger_area.body_entered.connect(_on_body_entered)
		use_this_trigger_area.area_entered.connect(_on_area_entered)

func _on_body_entered(body):
	if not body is Hero: return
	_produce_effect()

func _on_area_entered(area):
	if area is Bullet:
		if area.handled: return
		if not area.active: return
		_produce_effect()

func _produce_effect():
	for e in entities:
		if e:      
			match effect:
				Effects.QUEUE_FREE: _q_free(e)
				Effects.DISPLACE: _displace_entities(e)
				Effects.ENABLE: if not self.is_ancestor_of(e): add_child(e)
				Effects.RESET_BEHAVIOR: _reset_resetibles(e)
				Effects.SET_CURRENTLY_DEAD:
					if e.has_method("set_currently_dead"):
						e.set_currently_dead()
					else:
						push_warning(self.name, ": ", e.name, " has no set_currently_dead() method.")

func _add_children_to_entities():
	for c in get_children():
		if not c is CollisionShape2D:
			entities.append(c)

func _displace_entities(e: Node):
	if e is Node2D:
		e.global_position = destination
		if send_to_save_manager: SaveManager.log_entity_change(e, {"move_to": destination})

func _disable_entities():
	for e in entities:
		if e!= null: remove_child(e)

func _q_free(e: Node):
	if send_to_save_manager: SaveManager.log_entity_change(e, "dead")
	e.queue_free()

func _reset_resetibles(e: Node):
	for child in e.get_children():
		if child.is_in_group("resetables"):
			child.reset_behavior()
