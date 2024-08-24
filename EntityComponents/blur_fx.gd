extends Node2D

@export var trail_length = 5
@export var fade_time = 0.2
@export var starting_alpha = 0.5
@export var target_path: NodePath
@export var opaque_copies = false
var target: AnimatedSprite2D
var trail_sprites: Array[Sprite2D] = []
var active_sprites: Array[Sprite2D] = []
var positions: Array = []
var animations: Array = []
var frames: Array = []
var scales: Array = []
var times: Array = []
var generating_copies = false

func _ready():
	if target_path:
		target = get_node(target_path)
	
	if not target or not (target is AnimatedSprite2D):
		push_error("Error: Target is not set or is not an AnimatedSprite2D")
		return

	z_index = target.z_index - 1
	
	# Create pool of trail sprites
	for i in range(trail_length):
		var trail_sprite = Sprite2D.new()
		trail_sprite.texture = target.sprite_frames.get_frame_texture(target.animation, 0)
		trail_sprite.modulate.a = 0  # Start invisible
		trail_sprite.centered = target.centered
		trail_sprite.offset = target.offset
		trail_sprite.z_index = -i - 1
		trail_sprite.use_parent_material = true
		add_child(trail_sprite)
		trail_sprites.append(trail_sprite)
	
	# Initialize arrays with default values
	for i in range(trail_length):
		positions.append(Vector2.ZERO)
		animations.append(target.animation)
		frames.append(0)
		scales.append(Vector2.ONE)
		times.append(0.0)

func _process(delta: float) -> void:
	if not is_instance_valid(target) or not (target is AnimatedSprite2D):
		return
	
	var parent_scale = target.get_parent().scale if target.get_parent() is Node2D else Vector2.ONE
	
	if generating_copies:
		# Shift data in arrays
		for i in range(trail_length - 1, 0, -1):
			positions[i] = positions[i-1]
			animations[i] = animations[i-1]
			frames[i] = frames[i-1]
			scales[i] = scales[i-1]
			times[i] = times[i-1]
		
		# Add current data
		positions[0] = target.global_position
		animations[0] = target.animation
		frames[0] = target.frame
		scales[0] = Vector2(abs(parent_scale.x) * target.scale.x, parent_scale.y * target.scale.y)
		times[0] = 0.0
		
		# Activate a sprite from the pool if needed
		if active_sprites.size() < trail_length:
			var sprite = trail_sprites[active_sprites.size()]
			active_sprites.append(sprite)
	
	# Update active trail sprites
	var i = 0
	while i < active_sprites.size():
		var sprite = active_sprites[i]
		sprite.global_position = positions[i]
		sprite.texture = target.sprite_frames.get_frame_texture(animations[i], frames[i])
		sprite.flip_h = parent_scale.x < 0
		sprite.scale = scales[i]
		
		times[i] += delta
		if opaque_copies:
			sprite.modulate.a = 1.0 if times[i] < fade_time else 0.0
		else:
			var alpha = starting_alpha - (times[i] / fade_time)
			sprite.modulate.a = max(0, alpha)
		
		# Deactivate sprite if it's faded out
		if sprite.modulate.a <= 0:
			active_sprites.remove_at(i)
		else:
			i += 1

func clear_trail() -> void:
	active_sprites.clear()
	for i in range(trail_length):
		trail_sprites[i].modulate.a = 0
		positions[i] = Vector2.ZERO
		animations[i] = target.animation
		frames[i] = 0
		scales[i] = Vector2.ONE
		times[i] = 0.0
