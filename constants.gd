extends Node

enum Axes {x, y, both}
enum RegName {TEST = 0, INTRO = 1, HUB = 2, ICE = 3, FIRE = 4, CAVE = 5}
enum BulletType {REGULAR = 0, FIRE = 1, UNDERWATER = 2}

const BULLET_POOL_SIZE: int = 50

const HERO_COLORS:Array[Color] =					[Color(0.0, 0.0, 0.0),	Color(1.0, 1.0, 1.0)]
const BULLET_REGULAR_COLORS:Array[Color] =			[Color(0.0, 0.0, 0.0), 	Color(1.0, 1.0, 1.0)]
const BULLET_REGULAR_DULL_COLORS:Array[Color] =		[Color(0.0, 0.0, 0.0),	Color(1.0, 1.0, 1.0)]
const BULLET_FIRE_COLORS:Array[Color] =				[Color(1.0, 0.5, 0.5), 	Color(1.0, 1.0, 0.0)]
const BULLET_FIRE_DULL_COLORS:Array[Color] =		[Color(1.0, 0.0, 0.5), 	Color(1.0, 0.0, 0.0)]
const BULLET_UNDERWATER_COLORS:Array[Color] =		[Color(0.0, 0.0, 1.0), 	Color(0.5, 0.5, 1.0)]
const BULLET_UNDERWATER_DULL_COLORS:Array[Color] =	[Color(0.0, 0.0, 1.0), 	Color(0.5, 0.5, 1.0)]
