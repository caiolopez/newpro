extends Node

enum Axes {x, y, both}
enum SwitchState {ON, OFF, TEMP_ON}
enum RegName {TEST = 0, INTRO = 1, HUB = 2, ICE = 3, FIRE = 4, CAVE = 5}
const BULLET_POOL_SIZE: int = 50

const HERO_DARK: Color = Color(0.163, 0.127, 0.798)
const HERO_LIGHT: Color = Color(0.023, 0.391, 0.584)
const BULLET_REGULAR_DARK: Color = Color(0.363, 0.127, 0.798)
const BULLET_REGULAR_LIGHT: Color = Color(0.33, 0.391, 0.584)
