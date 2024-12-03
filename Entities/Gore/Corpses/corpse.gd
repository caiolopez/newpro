@tool
extends Sprite2D

@export var particles_enabled: bool = true

func _ready() -> void:
	if particles_enabled == false:
		$GPUParticles2D.queue_free()
