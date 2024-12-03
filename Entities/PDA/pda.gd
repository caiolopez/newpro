extends Node2D

@export var targets: Array[Node2D]

func _ready() -> void:
	Events.hero_respawned_at_checkpoint.connect(_reset_status)


func pickup() -> void:
	$AnimatedSprite2D.play("pickup")
	activate_targets()


func _on_animated_sprite_2d_animation_finished() -> void:
	hide()


func activate_targets() -> void:
	for target in targets:
		if target.has_method("activate"):
			target.activate(self)


func _reset_status() -> void:
	show()
	$AnimatedSprite2D.play("default")
