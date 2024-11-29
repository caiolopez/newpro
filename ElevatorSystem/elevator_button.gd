class_name ElevatorButton extends Area2D

@export var type: button_type
@onready var elevator_system: ElevatorSystem = _find_elevator_system()
@onready var sprite_shader: BwShaderSetter = $BwShaderSetter
enum button_type {ORIGIN, DESTINATION}
var is_active: bool
var original_material: Material = null
var _blink_timer: Timer
var _blink_timer_turn: bool = false


func _ready():
	original_material = material
	set_inactive()
	area_entered.connect(_on_area_entered)
	_setup_blink()

func _on_area_entered(area):
	if not area is Bullet: return
	if area.handled: return
	if not is_active:
		if type == button_type.ORIGIN:
			elevator_system.send_elevator_to(&"origin")
		if type == button_type.DESTINATION:
			elevator_system.send_elevator_to(&"destination")
	Utils.colorize_silhouette(true, self, 0.1)
	area.kill_bullet()

func set_active():
	is_active = true
	$AnimatedSprite2D.play("on")
	_blink()

func set_inactive():
	is_active = false
	$AnimatedSprite2D.play("off")
	if type == elevator_system.current_state:
		sprite_shader.set_color_pair(Constants.ELEVATOR_BUTTON_UNAVAILABLE_COLORS)
	else:
		sprite_shader.set_color_pair(Constants.ELEVATOR_BUTTON_AVAILABLE_COLORS)

func _find_elevator_system() -> ElevatorSystem:
	var current_parent = get_parent()
	if current_parent is ElevatorSystem:
		return current_parent
	elif current_parent.get_parent() is ElevatorSystem:
		return current_parent.get_parent()
	return null

func _setup_blink():
	_blink_timer = Timer.new()
	add_child(_blink_timer)
	_blink_timer.wait_time = 0.25

func _blink():
	_blink_timer.stop()  # Stop any existing timer
	if _blink_timer.timeout.is_connected(_on_blink_timeout):
		_blink_timer.timeout.disconnect(_on_blink_timeout)
	_blink_timer.timeout.connect(_on_blink_timeout)
	_blink_timer.start()

func _on_blink_timeout():
	if is_active:
		_blink_timer_turn = !_blink_timer_turn
		if _blink_timer_turn:
			sprite_shader.set_color_pair(Constants.ELEVATOR_BUTTON_AVAILABLE_COLORS)
		else:
			sprite_shader.set_color_pair(Constants.ELEVATOR_BUTTON_UNAVAILABLE_COLORS)
