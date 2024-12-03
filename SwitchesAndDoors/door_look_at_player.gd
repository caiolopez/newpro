class_name DoorLookAtPlayer extends VisibleOnScreenEnabler2D

@onready var door_sprite: AnimatedSprite2D = get_parent()
var target: Node2D

func _ready() -> void:
	if AppManager.hero:
		target = AppManager.hero
	else:
		AppManager.hero_ready.connect(func():
			target = AppManager.hero
			)

func _physics_process(_delta: float) -> void:
	var x_dir: int = sign(target.global_position.x - self.global_position.x)
	var y_diff: int = int(target.global_position.y - self.global_position.y)

	var animation_name: StringName = &""
	animation_name = &"look_left" if x_dir == -1 else &"look_right"
	if y_diff < -80: animation_name += &"_up"
	elif y_diff > 80: animation_name += &"_down"

	door_sprite.animation = animation_name
