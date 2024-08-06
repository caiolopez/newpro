extends Node2D

enum Effects {FREE, RETURN_PROP, HIDE}
@export var effect: Effects = Effects.FREE
@export var hide_if_hero_dir_changed: bool = false

func _ready():
	Events.hero_changed_dir.connect(func(_dir):
		if hide_if_hero_dir_changed:
			get_parent().visible = false
		)
	get_parent().animation_finished.connect(func():
		match effect:
			Effects.FREE:
				get_parent().queue_free()
			Effects.RETURN_PROP:
				PropManager.return_prop(get_parent())
			Effects.HIDE:
				get_parent().visible = false
		)
