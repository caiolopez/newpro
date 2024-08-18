extends Node2D

@export var trail_length = 5 ## The number of copies in the trail
@export var fade_time = 0.2 ## Time (in seconds) for each copy to fade out (if not opaque)
@export var target_path: NodePath ## NodePath to the target AnimatedSprite2D
@export var opaque_copies = false ## If true, trail copies will be opaque. If false, they will fade out over time

var target: AnimatedSprite2D
var trail_sprites: Array[Sprite2D] = []
var positions: Array = []
var animations: Array = []
var frames: Array = []
var scales: Array = []
var times: Array = []

var generating_copies = false  # Boolean to control copy generation

func _ready():
	if target_path:
		target = get_node(target_path)
	
	if not target or not (target is AnimatedSprite2D):
		push_error("Error: Target is not set or is not an AnimatedSprite2D")
		return
	
	print("Target found: ", target.name)
	
	# Ensure this node is behind the target
	z_index = target.z_index - 1
	
	# Create trail sprites
	for i in range(trail_length):
		var trail_sprite = Sprite2D.new()
		trail_sprite.texture = target.sprite_frames.get_frame_texture(target.animation, 0)
		trail_sprite.modulate.a = 1 if opaque_copies else 0  # Start opaque if opaque_copies is true
		trail_sprite.centered = target.centered
		trail_sprite.offset = target.offset
		trail_sprite.z_index = -i - 1  # Ensure trail sprites are drawn in order behind the target
		add_child(trail_sprite)
		trail_sprites.append(trail_sprite)
	
	# Initialize arrays with default values
	for i in range(trail_length):
		positions.append(Vector2.ZERO)
		animations.append(target.animation)
		frames.append(0)
		scales.append(Vector2.ONE)
		times.append(0.0)
	
	print("Created ", trail_sprites.size(), " trail sprites")

func _process(delta: float) -> void:
	if not is_instance_valid(target) or not (target is AnimatedSprite2D):
		return
	
	var parent_scale = target.get_parent().scale if target.get_parent() is Node2D else Vector2.ONE
	
	if generating_copies:
		# Shift positions, animations, frames, scales, and times
		for i in range(trail_length - 1, 0, -1):
			positions[i] = positions[i-1]
			animations[i] = animations[i-1]
			frames[i] = frames[i-1]
			scales[i] = scales[i-1]
			times[i] = times[i-1]
		
		# Add current position, animation, frame, scale, and reset time
		positions[0] = target.global_position
		animations[0] = target.animation
		frames[0] = target.frame
		scales[0] = Vector2(abs(parent_scale.x) * target.scale.x, parent_scale.y * target.scale.y)
		times[0] = 0.0
	
	# Update trail sprites
	for i in range(trail_length):
		trail_sprites[i].global_position = positions[i]
		trail_sprites[i].texture = target.sprite_frames.get_frame_texture(animations[i], frames[i])
		trail_sprites[i].flip_h = parent_scale.x < 0
		trail_sprites[i].scale = scales[i]
		
		times[i] += delta
		if opaque_copies:
			trail_sprites[i].modulate.a = 1.0 if times[i] < fade_time else 0.0
		else:
			var alpha = 1.0 - (times[i] / fade_time)
			trail_sprites[i].modulate.a = max(0, alpha)

func set_generating_copies(value: bool) -> void:
	generating_copies = value

func clear_trail() -> void:
	for i in range(trail_length):
		trail_sprites[i].modulate.a = 0
		positions[i] = Vector2.ZERO
		animations[i] = target.animation
		frames[i] = 0
		scales[i] = Vector2.ONE
		times[i] = 0.0

func _exit_tree() -> void:
	for sprite in trail_sprites:
		sprite.queue_free()
