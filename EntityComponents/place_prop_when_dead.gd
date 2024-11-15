class_name PlacePropWhenDead extends Node

@export var prop_to_place: StringName
@export var amount: int = 1 ## The amount of props that are going to be instantiated.
@export var interval_between_placements: float = 0.1 ## The amount of time between each placement.
@export var random_radius: float = 0 ## Randomizes prop placement within this radius.
@export var color_pair_source: BwShaderSetter = null ## Select the source (BwShaderSetter node) of the color scheme to be applied into the placed props.
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
@onready var parent: Node2D = get_parent()

var prop_color_pair: Array[Color] = []
var _props_placed: int = 0
var _timer: Timer

func _ready():
	if dmg_taker != null:
		dmg_taker.died.connect(start_placing_props)
	
	if color_pair_source:
		prop_color_pair = color_pair_source.get_color()

func start_placing_props():
	_props_placed = 0
	place_next_prop()

func place_next_prop():
	if _props_placed < amount:
		var placement_position = parent.global_position
		if random_radius > 0:
			placement_position += Vector2(randf_range(-random_radius, random_radius), randf_range(-random_radius, random_radius))
		PropManager.place_prop(placement_position, prop_to_place, prop_color_pair)
		_props_placed += 1
		
		if _props_placed < amount:
			if not _timer:
				_timer = Timer.new()
				_timer.one_shot = true
				add_child(_timer)
			_timer.start(interval_between_placements)
			_timer.timeout.connect(place_next_prop, CONNECT_ONE_SHOT)
