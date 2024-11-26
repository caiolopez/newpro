extends AnimatedSprite2D

@onready var blink_timer: Timer = get_node("BlinkTimer")
@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

@export_enum("Two Eyes", "Three Eyes") var variant: String = "Two Eyes"

func _ready() -> void:
	if variant == "Two Eyes":
		frame = 0
	else:
		frame = 1


func _process(_delta: float) -> void:
	if blink_timer.is_stopped():
		blink_timer.wait_time = randf_range(1.0, 4.0)
		blink_timer.start()

		if variant == "Two Eyes":
			animation_player.play("blink1")
		else:
			animation_player.play("blink2")
