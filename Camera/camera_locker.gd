@tool
class_name CameraLocker extends Area2D

const debug_color_x: Color = Color(0, 0, 1, 0.5)
const debug_color_y: Color = Color(1, 0, 0, 0.5)
const debug_color_both: Color = Color(1, 0, 1, 0.5)

@export var axes_to_lock: Constants.Axes:
	get:
		return axes_to_lock
	set(value):
		queue_redraw()
		axes_to_lock = value
@export var center_at_edge: bool
var center_at: Marker2D

func _ready():
	draw.connect(debug_color_changer)
	if Engine.is_editor_hint():
		child_entered_tree.connect(func(_child): queue_redraw())
	
	# Updates center_at with the Marker2d object position
	for child in get_children():
		if child is Marker2D:
			center_at = child
			break
	
	# When a body collides with this trigger, call custom function
	body_entered.connect(on_hero_entered_locker)
	body_exited.connect(on_hero_exited_locker)

func on_hero_entered_locker(body: Node2D):
	if not body.is_in_group("heroes"): return
	var lock_position: Vector2
	if center_at_edge:
		lock_position = body.global_position
	else:
		lock_position = center_at.global_position
		
	Events.hero_entered_camera_locker.emit(self, axes_to_lock, lock_position)

func on_hero_exited_locker(body: Node2D):
	if not body.is_in_group("heroes"): return
	Events.hero_exited_camera_locker.emit(self, axes_to_lock)
	
func debug_color_changer():
	var color: Color
	if axes_to_lock == Constants.Axes.x: color = debug_color_x
	elif axes_to_lock == Constants.Axes.y: color = debug_color_y
	elif axes_to_lock == Constants.Axes.both: color = debug_color_both
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = color

func _on_tree_entered():
	if Engine.is_editor_hint():
		for child in get_children():
			if child is CollisionShape2D:
				var script = load("res://utils.gd").new()
				script.make_collision_shape_unique(child)
