extends Node2D

var original_material: Material = null
@onready var original_scale: Vector2 = scale
@onready var hero: = get_parent()
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	material.set_shader_parameter("replace_black", Constants.HERO_COLORS[0])
	material.set_shader_parameter("replace_white", Constants.HERO_COLORS[1])
	original_material = material

	animated_sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	var next_anim: StringName = &""
	match animated_sprite.animation:
		"fall_in": next_anim = &"fall_loop"
		"glide_in": next_anim = &"glide_loop"
	
	if next_anim != &"":
		animated_sprite.play(next_anim)

func _process(_delta):
		#rotation_degrees = hero.current_blunder_jump_angle
		scale.x = original_scale.x * hero.facing_direction
