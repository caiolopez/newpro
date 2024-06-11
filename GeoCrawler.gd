extends Area2D

enum Direction {UP, DOWN, LEFT, RIGHT}
var SPEED: float = 100.0
var velocity: Vector2 = Vector2(50, 0)
var was_col: bool = false

func _ready():
	$DownRC.force_raycast_update()
	pass


func update_direction():
	var changed: bool
	changed = was_col != $DownRC.is_colliding()
	was_col = $DownRC.is_colliding()
	if not changed:
		return

	# if $DownRC.is_colliding():
	#	var diff = to_local($DownRC.get_collision_point()) - $DownRC.position TODO define raycast object


	if not $DownRC.is_colliding():
		self.rotation_degrees += 90
		velocity = velocity.rotated(deg_to_rad(90))
		


func _physics_process(delta):
	update_direction()
	global_position += velocity * delta

