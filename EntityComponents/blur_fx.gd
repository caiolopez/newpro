extends Node2D

@export var trail_length = 5
@export var fade_time = 0.2
@export var target_path: NodePath
var target: AnimatedSprite2D
var trail_sprites: Array[Sprite2D] = []
var positions: Array = []
var scales: Array = []
var times: Array = []
var generating_copies = false

func _ready():
	target = get_node(target_path)
	if not target: return

	z_index = target.z_index - 1

	for i in range(trail_length):
		var trail_sprite = Sprite2D.new()
		trail_sprite.texture = target.sprite_frames.get_frame_texture(target.animation, 0)
		trail_sprite.visible = false
		trail_sprite.z_index = -i - 1
		trail_sprite.use_parent_material = true
		add_child(trail_sprite)
		trail_sprites.append(trail_sprite)

		positions.append(Vector2.ZERO)
		scales.append(Vector2.ONE)
		times.append(0.0)

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		return

	var parent_scale = target.get_parent().scale if target.get_parent() is Node2D else Vector2.ONE

	if generating_copies:
		for i in range(trail_length - 1, 0, -1):
			positions[i] = positions[i-1]
			scales[i] = scales[i-1]
			times[i] = times[i-1]

		positions[0] = target.global_position
		scales[0] = Vector2(abs(parent_scale.x) * target.scale.x, parent_scale.y * target.scale.y)
		times[0] = 0.0

	for i in range(trail_length):
		var sprite = trail_sprites[i]
		sprite.global_position = positions[i]
		sprite.texture = target.sprite_frames.get_frame_texture(target.animation, target.frame)
		sprite.flip_h = parent_scale.x < 0
		sprite.scale = scales[i]
		
		times[i] += delta
		sprite.visible = times[i] < fade_time and generating_copies

func clear_trail() -> void:
	for i in range(trail_length):
		trail_sprites[i].visible = false
		positions[i] = Vector2.ZERO
		scales[i] = Vector2.ONE
		times[i] = 0.0
