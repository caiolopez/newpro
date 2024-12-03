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
	AudioManager.play_sfx(&"blunderjump1", -16.0)

# Basically unused for now
func hero_recoil_sfx():
	pass

func hero_wall_jump_sfx():
	AudioManager.play_sfx(&"wallclimb_metal", -20.0)

func hero_wall_climb_sfx():
	AudioManager.play_sfx(&"wallclimb_metal", -24.0)

func hero_glide_start_sfx():
	AudioManager.play_sfx(&"parachute_open", -20.0)

func hero_wall_grab_sfx():
	AudioManager.play_sfx(&"footstep", -30.0)

func hero_die_sfx():
	AudioManager.play_sfx(&"death", -18.0)

# Basically unused for now
func hero_tweening_to_respawn_sfx():
	pass

func hero_respawn_sfx():
	AudioManager.play_sfx(&"respawn", -24.0)

func bullet_die_sfx():
	AudioManager.play_sfx(&"impact1", -18.0)

func door_open_sfx():
	AudioManager.play_sfx(&"door1_open", -6.0)

func door_close_sfx():
	AudioManager.play_sfx(&"door1_close", -8.0)

func switch_on_sfx():
	AudioManager.play_sfx(&"switch1_on", -8.0)

func switch_off_sfx():
	AudioManager.play_sfx(&"switch1_off", -8.0)

func timed_door_beep_sfx(): # An intermitent beep signaling that this switch will close itself eventually.
	AudioManager.play_sfx(&"switch_beep", -3.0)

func boss1_wakes_sfx():
	AudioManager.play_sfx(&"boss1_awakes", -12.0)

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
