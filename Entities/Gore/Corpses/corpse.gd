extends Sprite2D

@export var particles: PackedScene
@export var environment_trigger: PackedScene

func _ready() -> void:
	if particles:
		var particles_instance: GPUParticles2D = particles.instantiate()
		add_child(particles_instance)

	if environment_trigger:
		var environment_trigger_instance: EnvironmentalTrigger = environment_trigger.instantiate()
		add_child(environment_trigger_instance)
