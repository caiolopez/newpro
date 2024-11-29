class_name Ignitable extends Area2D

@export var duration: float = 5.0
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(get_parent())
@onready var parent: Node2D = get_parent()
var is_ignited: bool = false
var ignition_timer: Timer

func _ready() -> void:
	area_entered.connect(func(area):
		if self.is_ignited:
			if area is Ignitable and not area.is_ignited:
				area.ignite()
				if DebugTools.print_stuff: print(area, " was ignited by ", self)
		elif area is Bullet\
		and area.bullet_type == Constants.BulletTypes.FIRE:
			self.ignite()
	)
	dmg_taker.died.connect(on_died)
	dmg_taker.resurrected.connect(on_resurrected)
	
	ignition_timer = Timer.new()
	ignition_timer.one_shot = true
	ignition_timer.timeout.connect(deignite)
	add_child(ignition_timer)

func ignite() -> void:
	is_ignited = true
	ignition_timer.start(duration)

func deignite() -> void:
	dmg_taker.take_dmg(1)
	is_ignited = false

func on_died():
	ignition_timer.stop()
	is_ignited = false

func on_resurrected():
	ignition_timer.stop()
	is_ignited = false
