class_name Effector extends Area2D

enum Effects {
	QUEUE_FREE, ## Deletes affected nodes forever.
	DISPLACE, ## Changes the global position of affected nodes, provided that they are Node2D.
	ENABLE, ## Disables all affected nodes upon start so that, when activated, the affected nodes are all enabled.
	RESET_BEHAVIOR ## Calls reset_behavior() on all affected nodes, provided that they are within "resetables" group and have such method.
	}
@export var effect: Effects = Effects.QUEUE_FREE ## The effect that will happen to all children of this node, as well as to any node appended to the Entities Array.
@export var destination: Vector2 ## If set to displace entities, this is the global position they will be instantly moved to.
@export var entities: Array[Node] ## The entities that will be affected. Note: All children of Effector will automatically be included in this Array.
@export var send_to_save_manager: bool = true ## When set to true, logs the changes so that effects are reapplied upon reloading region. Note: only works for queue free and displace.


func _ready():
	body_entered.connect(on_body_entered)
	add_children_to_entities()
	if effect == Effects.ENABLE:
		disable_entities()


func on_body_entered(body):
	if not body is Hero: return
	for e in entities:
		if e != null and is_instance_valid(e):      
			match effect:
				Effects.QUEUE_FREE: q_free(e)
				Effects.DISPLACE: displace_entities(e)
				Effects.ENABLE: if not self.is_ancestor_of(e): add_child(e)
				Effects.RESET_BEHAVIOR: reset_resetibles(e)


func add_children_to_entities():
	for c in get_children():
		if not c == UniqueCollider:
			entities.append(c)


func displace_entities(e: Node):
	if e is Node2D:
		e.global_position = destination
		if send_to_save_manager: SaveManager.log_entity_change(e.get_path(), {"move_to": destination})

func disable_entities():
	for e in entities:
		if e!= null: remove_child(e)

func q_free(e: Node):
	if send_to_save_manager: SaveManager.log_entity_change(e.get_path(), "dead")
	e.queue_free()

func reset_resetibles(e: Node):
	for child in e.get_children():
		if child.is_in_group("resetables"):
			child.reset_behavior()
