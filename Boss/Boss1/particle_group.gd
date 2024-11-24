extends Node2D

var _particles: Array[GPUParticles2D] = []

func _ready() -> void:
	for child in get_children():
		if child is GPUParticles2D:
			_particles.append(child)

func emit_particles() -> void:
	for particle in _particles:
		particle.emitting = true

func set_amount_for_each(amount: int) -> void:
	for particle in _particles:
		particle.amount = amount
