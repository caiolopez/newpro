class_name HideWhenHeroDead extends Node

var parent_og_visibility: bool

func _ready() -> void:
	parent_og_visibility = get_parent().visible
	
	Events.hero_died.connect(func():
		get_parent().visible = false
		)
	Events.hero_respawned_at_checkpoint.connect(func():
		get_parent().visible = parent_og_visibility
		get_parent().reset_physics_interpolation()
		)
