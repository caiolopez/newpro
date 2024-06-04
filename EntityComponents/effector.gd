extends Area2D

@export var free_entity: bool = false
@export var displace_entity: bool = false
@export var destination: Vector2
@export var victims: Array[Node]

func _ready():
	body_entered.connect(on_body_entered)

func on_body_entered(body):
	if not body.is_in_group("heroes"): return
	for v in victims:
		if v!= null:
			if free_entity: v.queue_free()
			if displace_entity: v.global_position = destination
