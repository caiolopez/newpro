extends Node2D

@export var cloning_frequence = 30 ## The amount of clones created every second.
@export var clone_lifetime = 0.15 ## The lifetime of a clone, from creating to being hidden.
@export var target: AnimatedSprite2D

var trail_sprites: Array[Sprite2D] = []
var positions: Array = []
var scales: Array = []
var times: Array = []
var textures: Array = []
var flips: Array = []
var generating_clones = false
var time_since_last_clone = 0.0

func start_generating():
	generating_clones = true

func stop_generating():
	generating_clones = false

func _ready():
	if not target: return

	z_index = target.z_index - 1

	for i in range(cloning_frequence):
		var trail_sprite = Sprite2D.new()
		trail_sprite.visible = false
		trail_sprite.use_parent_material = true
		add_child(trail_sprite)
		trail_sprites.append(trail_sprite)

		positions.append(Vector2.ZERO)
		scales.append(Vector2.ONE)
		times.append(-1.0)  # Initialize with -1 to indicate inactive clone
		textures.append(null)
		flips.append(false)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return

	var parent_scale = target.get_parent().scale if target.get_parent() is Node2D else Vector2.ONE

	if generating_clones:
		time_since_last_clone += delta
		if time_since_last_clone >= 1.0 / cloning_frequence:
			time_since_last_clone = 0.0
			create_new_clone(parent_scale)

	update_clones(delta)

func create_new_clone(parent_scale: Vector2):
	for i in range(cloning_frequence):
		if times[i] < 0:  # Find the first inactive clone
			positions[i] = target.global_position
			scales[i] = Vector2(abs(parent_scale.x) * target.scale.x, parent_scale.y * target.scale.y)
			times[i] = 0.0
			textures[i] = target.sprite_frames.get_frame_texture(target.animation, target.frame)
			flips[i] = parent_scale.x < 0
			trail_sprites[i].z_index = z_index - 1  # Set z_index for newest clone
			# Decrease z_index of other active clones
			for j in range(cloning_frequence):
				if j != i and times[j] >= 0:
					trail_sprites[j].z_index -= 1
			break

func update_clones(delta: float):
	for i in range(cloning_frequence):
		var sprite = trail_sprites[i]
		if times[i] >= 0:  # Active clone
			sprite.global_position = positions[i]
			sprite.texture = textures[i]
			sprite.flip_h = flips[i]
			sprite.scale = scales[i]
			
			times[i] += delta
			if times[i] >= clone_lifetime:
				sprite.visible = false
				times[i] = -1.0  # Deactivate the clone
			else:
				sprite.visible = true
				sprite.reset_physics_interpolation() # Important.
		else:
			sprite.visible = false

func clear_trail() -> void:
	for i in range(cloning_frequence):
		trail_sprites[i].visible = false
		positions[i] = Vector2.ZERO
		scales[i] = Vector2.ONE
		times[i] = -1.0  # Deactivate all clones
		textures[i] = null
		flips[i] = false
		trail_sprites[i].z_index = 0  # Reset z_index
