extends Node

enum Axes {HORIZONTAL_LOCK, VERTICAL_LOCK, FULL_LOCK}
enum RegName {TEST = -1, NULL = 0, INTRO = 1, HUB = 2, ICE = 3, FIRE = 4, CAVE = 5}
enum BulletTypes {REGULAR = 0, FIRE = 1, UNDERWATER = 2, LIVING = 3}
enum EnvironmentTypes {NORMAL = 0, GOO = 1} ## Change the sound hero makes

const HERO_COLORS:Array[Color] =							[Color(0.0, 0.0, 0.0),	Color(1.0, 1.0, 1.0)]
const HERO_ACCESSIBILITY_COLORS:Array[Color] =				[Color(0.0, 0.0, 0.0),	Color(1.0, 0.5, 1.0)]
const BULLET_REGULAR_COLORS:Array[Color] =					[Color(0.0, 0.0, 0.0), 	Color(1.0, 1.0, 1.0)]
const BULLET_REGULAR_DULL_COLORS:Array[Color] =				[Color(0.0, 0.0, 0.0),	Color(1.0, 1.0, 1.0)]
const BULLET_FIRE_COLORS:Array[Color] =						[Color(1.0, 0.5, 0.5), 	Color(1.0, 1.0, 0.0)]
const BULLET_FIRE_DULL_COLORS:Array[Color] =				[Color(1.0, 0.0, 0.5), 	Color(1.0, 0.0, 0.0)]
const BULLET_UNDERWATER_COLORS:Array[Color] =				[Color(0.0, 0.0, 1.0), 	Color(0.5, 0.5, 1.0)]
const BULLET_UNDERWATER_DULL_COLORS:Array[Color] =			[Color(0.0, 0.0, 1.0), 	Color(0.5, 0.5, 1.0)]
const BULLET_LIVING_COLORS: Array[Color] =					[Color("040414"), Color("fe074e")]

const SWITCH_OFF_COLORS:Array[Color] = 						[Color("3f160b"), Color("f67f00")]
const SWITCH_ON_COLORS:Array[Color] = 						[Color("36221b"), Color("e0ac3c")]
const SWITCH_TEMP_ON_COLORS:Array[Color] = 					[Color("36221b"), Color("e0ac3c")]

const ELEVATOR_BUTTON_MOVING_COLORS:Array[Color] = 			[Color("36221b"), Color("e0ac3c")]
const ELEVATOR_BUTTON_UNAVAILABLE_COLORS:Array[Color] =		[Color("040414"), Color("091645")]
const ELEVATOR_BUTTON_AVAILABLE_COLORS:Array[Color] =		[Color("3f160b"), Color("f67f00")]

const BOSS_STAGE0_COLORS:Array[Color] = 					[Color("36221b"),		Color("e0ac3c")]
const BOSS_STAGE1_COLORS:Array[Color] = 					[Color("3f160b"),		Color("f67f00")]
const BOSS_STAGE2_COLORS:Array[Color] = 					[Color("3f0511"),		Color("f94a22")]
const BOSS_STAGE3_COLORS:Array[Color] = 					[Color("040414"),		Color("fe074e")]

const REGION1_COLORS: Array[Color] = [Color("091645"), Color("0a4e7b")]
const REGION1_TILE_LIGHT: Color = Color("0a4e7b")
const REGION1_TILE_DARK: Color = Color("091645")
const ZONE_1_BG_COLOR: Color = Color("040414")
const GORE_LIGHT: Color = Color("8e0b4a")
const GORE_DARK: Color = Color("201020")
const ENEMY_LIGHT: Color = Color("fe074e")
const ELEVATOR_LIGHT: Color = Color("f67f00")
const ELEVATOR_DARK: Color = Color("3f160b")
const ELEVATOR_BG: Color = Color("140404")
