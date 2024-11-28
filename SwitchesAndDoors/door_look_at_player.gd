extends Node2D

@onready var door_sprite: AnimatedSprite2D = get_parent()
var target: Node2D

func _physics_process(_delta: float) -> void:
	if !target:
		door_sprite.animation = "open"
		return

	# Probably not the best way to do this, but I wrote this at 4AM so uuuuh...
	# - Hexany
	if target.global_position.x < self.global_position.x:
		if target.global_position.y < self.global_position.y - 80.0:
			door_sprite.animation = "look_left_up"
		elif target.global_position.y > self.global_position.y + 80.0:
			door_sprite.animation = "look_left_down"
		else:
			door_sprite.animation = "look_left"
	else:
		if target.global_position.y < self.global_position.y - 80.0:
			door_sprite.animation = "look_right_up"
		elif target.global_position.y > self.global_position.y + 80.0:
			door_sprite.animation = "look_right_down"
		else:
			door_sprite.animation = "look_right"


func _on_smart_area_2d_body_entered(body: Node2D) -> void:
	target = body


func _on_smart_area_2d_body_exited(_body: Node2D) -> void:
	target = null
