extends AnimatedSprite2D

@onready var blink_timer: Timer = $BlinkTimer

func _process(_delta: float) -> void:
	if blink_timer.is_stopped():
		blink_timer.wait_time = randf_range(1.0, 4.0)
		blink_timer.start()

		play("blink")
