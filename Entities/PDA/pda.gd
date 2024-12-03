extends Node2D

func _on_animated_sprite_2d_animation_finished() -> void:
	SaveManager.log_entity_change(self, "dead")
	queue_free()
