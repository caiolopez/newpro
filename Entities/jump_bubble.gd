class_name Bubble extends Area2D

@export var cooldown_time: float = 1.0
@export var strength: float = 1000.0
var is_on_cooldown: bool = false
var cooldown_timer: Timer

func _ready() -> void:
	body_entered.connect(func(body):
		if not body is Hero: return
		if not body.state_machine.current_state.death_prone: return
		if is_on_cooldown: return
		Events.hero_touched_bubble.emit(self)
		)

	Events.hero_respawned_at_checkpoint.connect(_reappear)

	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.timeout.connect(_reappear)
	add_child(cooldown_timer)

func _reappear() -> void:
	is_on_cooldown = false
	show()
	for body in get_overlapping_bodies():
		if body is Hero and body.state_machine.current_state.death_prone:
			Events.hero_touched_bubble.emit(self)
			break

func burst() -> void:
	hide()
	is_on_cooldown = true
	cooldown_timer.start()
