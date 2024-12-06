extends Node

enum Effects {FREE, RETURN_PROP, HIDE, REPLACE_ANIMATION}
@export var animation_name: StringName = &"" # Optional animation filter.
@export var effect: Effects = Effects.FREE # What happens when the animation ends.
@export var next_animation_name: StringName = &"" # If set to replace animation.
@onready var parent = get_parent()

func _ready() -> void:
	get_parent().animation_finished.connect(func():
		if animation_name and parent.animation != animation_name: return

		match effect:
			Effects.FREE:
				parent.queue_free()
			Effects.RETURN_PROP:
				PropManager.return_prop(parent)
			Effects.HIDE:
				parent.visible = false
			Effects.REPLACE_ANIMATION:
				if next_animation_name:
					parent.play(next_animation_name)
		)
