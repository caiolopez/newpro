class_name HeroState extends _State

var hero: CharacterBody2D
var timer_coyote_jump: Timer
var timer_buffer_jump: Timer
var timer_coyote_wall: Timer
var timer_buffer_wall_jump: Timer
var timer_wall_jump_duration: Timer
var timer_blunder_shoot_duration: Timer
var timer_blunder_shoot_cooldown: Timer
var timer_blunder_jump_window: Timer
var timer_leaving_wall: Timer
var timer_buffer_climbing: Timer
var timer_death_snapshot: Timer
var timer_super_bounce_window: Timer


func enter(new_machine:StateMachine) -> void:
	timer_coyote_jump = get_node("../TimerCoyoteJump")
	timer_buffer_jump = get_node("../TimerBufferJump")
	timer_coyote_wall = get_node("../TimerCoyoteWall")
	timer_buffer_wall_jump = get_node("../TimerBufferWallJump")
	timer_wall_jump_duration = get_node("../TimerWallJumpDuration")
	timer_blunder_shoot_duration = get_node("../TimerBlunderShootDuration")
	timer_blunder_shoot_cooldown = get_node("../TimerBlunderShootCooldown")
	timer_blunder_jump_window = get_node("../TimerBlunderJumpWindow")
	timer_leaving_wall = get_node("../TimerLeavingWall")
	timer_buffer_climbing = get_node("../TimerBufferClimbing")
	timer_death_snapshot = get_node("../TimerDeathSnapshot")
	timer_super_bounce_window = get_node("../TimerSuperBounceWindow")
	
	hero = new_machine.owner as CharacterBody2D
	super(new_machine)


