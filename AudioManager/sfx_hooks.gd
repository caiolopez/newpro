extends Node

func hero_shoot_sfx():
	pass

func hero_blunder_shoot_sfx(): # shoots a shotgun-like spread
	pass

func hero_jump_sfx():
	pass

func hero_fall_sfx():
	pass

func hero_step_sfx():
	pass

func hero_blunder_jump_sfx():
	pass

func hero_recoil_sfx():
	pass

func hero_wall_jump_sfx():
	pass

func hero_glide_start_sfx():
	pass

func hero_wall_grab_sfx():
	pass

func hero_die_sfx():
	pass

func hero_tweening_to_respawn_sfx():
	pass

func hero_respawn_sfx():
	pass

func bullet_die_sfx():
	pass

func door_open_sfx():
	pass

func door_close_sfx():
	pass

func elevator_start_sfx(): #####
	pass

func elevator_stop_sfx(): #####
	pass

func elevator_move_sfx(): #####
	pass

func switch_on_sfx():
	pass

func switch_off_sfx():
	pass

func timed_door_beep_sfx(): # An intermitent beep signaling that this switch will close itself eventually.
	AudioManager.play_sfx(&"snare")
	pass

func boss1_wakes_sfx():
	pass

func boss1_fight_start_sfx():
	pass

func boss1_pre_dash_sfx():
	pass

func boss1_dash_sfx():
	pass

func boss1_post_dash_sfx(): # Boss1 hits head against the wall
	pass

func boss1_change_level_sfx():
	pass

# Boss1 shooting: set in Boss1 Shooter Component
# Boss1 suffer: set in Boss1 DmgTaker Component
# Boss1 death: set in Boss1 DmgTaker Component