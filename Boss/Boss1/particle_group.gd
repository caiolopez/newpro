extends Node2D

@export var particle_scenes: Array[PackedScene] = []

var particle_amount: int = 5

func emit_particles() -> void:
	for particles_scene in particle_scenes:
		var particles_instance: GPUParticles2D = particles_scene.instantiate()
		add_child(particles_instance)
		particles_instance.amount = particle_amount
		particles_instance.emitting = true
		particles_instance.use_parent_material = true

		particles_instance.finished.connect(func(): 
			particles_instance.queue_free()
			print(particles_instance.name + " killed!")
		)


func set_amount_for_each(amount: int) -> void:
	particle_amount = amount
