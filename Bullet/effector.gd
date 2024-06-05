class_name Effector extends Area2D

enum Effects {QUEUE_FREE, DISPLACE, ENABLE}
@export var effect: Effects = Effects.QUEUE_FREE ## The effect that will happen to all children of this node.
@export var destination: Vector2 ## If set to displace entities, this is the global position they will be instantly moved to.
var entities: Array[Node]


func _ready():
	body_entered.connect(on_body_entered)
	add_children_to_entities()
	if effect == Effects.ENABLE:
		disable_entities()


func on_body_entered(body):
	if not body.is_in_group("heroes"): return
	for e in entities:
		if e != null:
			match effect:
				Effects.QUEUE_FREE: e.queue_free()
				Effects.DISPLACE: e.global_position = destination
				Effects.ENABLE: add_child(e)


func add_children_to_entities():
	for c in get_children():
		if not c is CollisionShape2D:
			entities.append(c)


func disable_entities():
	for e in entities:
		if e!= null: remove_child(e)
