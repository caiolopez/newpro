class_name Effector extends Area2D

enum Effects {QUEUE_FREE, DISPLACE, ENABLE, RESET_BEHAVIOR}
@export var effect: Effects = Effects.QUEUE_FREE ## The effect that will happen to all children of this node.
@export var destination: Vector2 ## If set to displace entities, this is the global position they will be instantly moved to.
@export var entities: Array[Node] ## The entities that will be affected. Note: All children of Effector will automatically be included in this Array.


func _ready():
	body_entered.connect(on_body_entered)
	add_children_to_entities()
	if effect == Effects.ENABLE:
		disable_entities()


func on_body_entered(body):
	if not body is Hero: return
	for e in entities:
		if e != null:
			match effect:
				Effects.QUEUE_FREE: e.queue_free()
				Effects.DISPLACE: displace_entities(e)
				Effects.ENABLE: add_child(e)
				Effects.RESET_BEHAVIOR: reset_resetibles(e)


func add_children_to_entities():
	for c in get_children():
		if not c == $UniqueCollider:
			entities.append(c)


func displace_entities(e: Node):
	if e is Node2D:
		e.global_position = destination


func disable_entities():
	for e in entities:
		if e!= null: remove_child(e)


func reset_resetibles(e: Node):
	for child in e.get_children():
		if child.is_in_group("resetables"):
			child.reset_behavior()
