extends Sprite2D

@export var particles: PackedScene
@export var environment_trigger: PackedScene

var particles_instance: GPUParticles2D
var activated: bool = false

func _ready() -> void:
	Events.hero_reached_checkpoint.connect(_commit_status)
	Events.hero_respawned_at_checkpoint.connect(_reset_status)

	if particles:
		particles_instance = particles.instantiate()
		add_child(particles_instance)

	if environment_trigger:
		var environment_trigger_instance: EnvironmentalTrigger = environment_trigger.instantiate()
		add_child(environment_trigger_instance)

	material.set_shader_parameter("dissolve_value", 0.4)
	material.set_shader_parameter("blend_factor", 0.0)


func activate(_activator: Node) -> void:
	if activated:
		return

	activated = true

	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self.material, "shader_parameter/dissolve_value", 0.0, 1.0)
	tween.tween_property(self.material, "shader_parameter/blend_factor", 1.0, 0.5)

	if particles_instance:
		particles_instance.emitting = false


func _commit_status() -> void:
	if activated:
		SaveManager.log_entity_change(self, "dead")
		queue_free()


func _reset_status() -> void:
	activated = false

	show()
	material.set_shader_parameter("dissolve_value", 0.4)
	material.set_shader_parameter("blend_factor", 0.0)

	if particles_instance:
		particles_instance.emitting = true
