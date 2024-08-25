extends Node

enum Axes {x, y, both}
enum SwitchState {ON, OFF, TEMP_ON}
enum RegName {TEST = 0, INTRO = 1, HUB = 2, ICE = 3, FIRE = 4, CAVE = 5}
enum BulletType {REGULAR, FIRE, UNDERWATER}
const BULLET_POOL_SIZE: int = 50

const HERO_COLORS: Array[Color] = [Color(0, 0, 0), Color(1, 1, 1)]
const BULLET_REGULAR_DRY_COLORS: Array[Color] = [Color(0, 0, 0), Color(1, 1, 1)]
const BULLET_REGULAR_WET_COLORS: Array[Color] = [Color(0, 0, 0), Color(1, 1, 1)]
const BULLET_FIRE_DRY_COLORS: Array[Color] = [Color(1, 0.5, 0.5), Color(1, 1, 0)]
const BULLET_FIRE_WET_COLORS: Array[Color] = [Color(1, 0, 0.5), Color(1, 0, 0)]
const BULLET_UNDERWATER_DRY_COLORS: Array[Color] = [Color(1, 0.5, 0.5), Color(1, 1, 0)]
const BULLET_UNDERWATER_WET_COLORS: Array[Color] = [Color(0, 0, 1), Color(0.5, 0.5, 1)]
