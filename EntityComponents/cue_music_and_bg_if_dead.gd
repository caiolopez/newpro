class_name CueMusicAndBGIfDead extends Node

@export var background: StringName = ""
@export var track: StringName = ""
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())

func _ready() -> void:
	if dmg_taker != null:
		dmg_taker.died.connect(func():
			if AppManager.hero.is_currently_dead(): return
			if background: BackgroundManager.change_background(background)
			if track: AudioManager.play_music(track)
			)
