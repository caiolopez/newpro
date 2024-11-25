extends Node

enum Axes {HORIZONTAL_LOCK, VERTICAL_LOCK, FULL_LOCK}
enum RegName {TEST = -1, NULL = 0, INTRO = 1, HUB = 2, ICE = 3, FIRE = 4, CAVE = 5}
enum BulletType {REGULAR = 0, FIRE = 1, UNDERWATER = 2}

const BULLET_POOL_SIZE: int = 50

const HERO_COLORS:Array[Color] =						[Color(0.0, 0.0, 0.0),	Color(1.0, 1.0, 1.0)]
const BULLET_REGULAR_COLORS:Array[Color] =				[Color(0.0, 0.0, 0.0), 	Color(1.0, 1.0, 1.0)]
const BULLET_REGULAR_DULL_COLORS:Array[Color] =			[Color(0.0, 0.0, 0.0),	Color(1.0, 1.0, 1.0)]
const BULLET_FIRE_COLORS:Array[Color] =					[Color(1.0, 0.5, 0.5), 	Color(1.0, 1.0, 0.0)]
const BULLET_FIRE_DULL_COLORS:Array[Color] =			[Color(1.0, 0.0, 0.5), 	Color(1.0, 0.0, 0.0)]
const BULLET_UNDERWATER_COLORS:Array[Color] =			[Color(0.0, 0.0, 1.0), 	Color(0.5, 0.5, 1.0)]
const BULLET_UNDERWATER_DULL_COLORS:Array[Color] =		[Color(0.0, 0.0, 1.0), 	Color(0.5, 0.5, 1.0)]

const SWITCH_OFF_COLORS:Array[Color] = 					[Color(0.5, 0.0, 0.0), 	Color(1.0, 0.5, 0.5)]
const SWITCH_ON_COLORS:Array[Color] = 					[Color(0.0, 0.5, 0.0), 	Color(0.5, 1.0, 0.5)]
const SWITCH_TEMP_ON_COLORS:Array[Color] = 				[Color(0.5, 0.5, 0.0), 	Color(1.0, 1.0, 0.5)]

const ELEVATOR_BUTTON_MOVING_COLORS:Array[Color] = 		[Color(0.0, 0.5, 0.0),		Color(0.5, 1.0, 0.5)]
const ELEVATOR_BUTTON_UNAVAILABLE_COLORS:Array[Color] =	[Color(0.25, 0.12, 0.0), 	Color(0.5, 0.25, 0.0)]
const ELEVATOR_BUTTON_AVAILABLE_COLORS:Array[Color] =	[Color(0.5, 0.25, 0.0), 	Color(1.0, 0.5, 0.0)]

const BOSS_STAGE0_COLORS:Array[Color] = 		[Color("000000"),		Color("e0ac3c")]
const BOSS_STAGE1_COLORS:Array[Color] = 		[Color("000000"),		Color("f67f00")]
const BOSS_STAGE2_COLORS:Array[Color] = 		[Color("000000"),		Color("f94a22")]
const BOSS_STAGE3_COLORS:Array[Color] = 		[Color("000000"),		Color("fe074e")]
