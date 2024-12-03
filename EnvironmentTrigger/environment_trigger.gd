class_name EnvironmentalTrigger extends Area2D

@export var environment: Constants.EnvironmentTypes = Constants.EnvironmentTypes.NORMAL

func _ready() -> void:
	Events.hero_respawned_at_checkpoint.connect(_reappear)

	body_entered.connect(func(body):
		if body is Hero:
			body.current_environment = environment
			)
	body_exited.connect(func(body):
		if body is Hero:
			body.current_environment = Constants.EnvironmentTypes.NORMAL
			)

func _reappear() -> void:
	for body in get_overlapping_bodies():
		if body is Hero and body.state_machine.current_state.death_prone:
			body.current_environment = environment
			break
