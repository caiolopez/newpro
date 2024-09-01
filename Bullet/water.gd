class_name Water extends Area2D

var collider: CollisionShape2D
@onready var surface_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			collider = child
	place_surface_art()

func get_surface_global_position() -> float:
	var shape_extents = collider.shape.extents
	return collider.global_position.y - shape_extents.y

func place_surface_art() -> void:
	var shape_extents = collider.shape.extents
	var sprite_width = surface_sprite.sprite_frames.get_frame_texture("default", 0).get_width()
	var num_sprites = ceil(shape_extents.x * 2 / sprite_width)
	
	for i in range(num_sprites):
		var new_sprite = surface_sprite.duplicate()
		add_child(new_sprite)
		new_sprite.position.x = -shape_extents.x + (i * sprite_width)
		new_sprite.global_position.y = get_surface_global_position() - 30
	
	surface_sprite.queue_free()
