class_name OpenDoorsIfDead extends Node

@export var doors_to_open: Array[Door] = [] ## Optional list of simple doors to open when parent entity is dead.
@export var switch_group_to_open: SwitchGroupController = null ## Optional switch group to open when parent is dead.
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())

func _ready() -> void:
	if dmg_taker != null:
		dmg_taker.died.connect(func():
			if AppManager.hero.is_currently_dead(): return
			for d in doors_to_open:
				if d: d.open()
			if switch_group_to_open:
				switch_group_to_open.open_whole_group()
			)
		dmg_taker.restored.connect(func():
			for d in doors_to_open:
				if d: d.insta_close()
			if switch_group_to_open:
				switch_group_to_open.close_whole_group(SwitchGroupController.INSTANTLY)
			)
