extends Node

func hero_shoot_sfx():
	AudioManager.play_sfx(&"shot", -8.0)

func hero_blunder_shoot_sfx(): # shoots a shotgun-like spread
	AudioManager.play_sfx(&"dash1", -6.0)

func hero_jump_sfx():
	AudioManager.play_sfx(&"jump", -24.0)

func hero_fall_sfx():
	AudioManager.play_sfx(&"land", -24.0)

func hero_step_sfx():
	AudioManager.play_sfx(&"footstep", -30.0)

func hero_blunder_jump_sfx():
	AudioManager.play_sfx(&"dash1", -12.0) # placeholder

func hero_recoil_sfx():
	pass

func hero_wall_jump_sfx():
	AudioManager.play_sfx(&"jump", -24.0) # placeholder

func hero_wall_climb_sfx():
	AudioManager.play_sfx(&"jump", -24.0) # placeholder

func hero_glide_start_sfx():
	AudioManager.play_sfx(&"jump", -24.0) # placeholder

func hero_wall_grab_sfx():
	AudioManager.play_sfx(&"footstep", -30.0)

func hero_die_sfx():
	AudioManager.play_sfx(&"death", -18.0)

func hero_tweening_to_respawn_sfx():
	pass

func hero_respawn_sfx():
	AudioManager.play_sfx(&"respawn", -24.0)

func bullet_die_sfx():
	AudioManager.play_sfx(&"impact1", -18.0)

func door_open_sfx():
	pass

func door_close_sfx():
	pass

# Elevator sounds and loops ar dealt directly in ElevatorSystem node.

func switch_on_sfx():
	pass

func switch_off_sfx():
	pass

func timed_door_beep_sfx(): # An intermitent beep signaling that this switch will close itself eventually.
	pass

func boss1_wakes_sfx():
	pass

func boss1_fight_start_sfx():
	pass

func boss1_pre_dash_sfx():
	AudioManager.play_sfx(&"boss1_charge_start", -14.0)

func boss1_dash_sfx():
	AudioManager.play_sfx(&"boss1_charge", -8.0)

func boss1_post_dash_sfx(): # Boss1 hits head against the wall
	AudioManager.play_sfx(&"boss1_hits_wall", -12.0)

func boss1_change_level_sfx():
	AudioManager.play_sfx(&"boss1_stage_change", -8.0)

# Boss1 shooting: set in Boss1 Shooter Component
# Boss1 suffer: set in Boss1 DmgTaker Component
# Boss1 death: set in Boss1 DmgTaker Component
