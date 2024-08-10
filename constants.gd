extends Node

enum Axes {x, y, both}
enum SwitchState {ON, OFF, TEMP_ON}
enum RegName {TEST = 0, INTRO = 1, HUB = 2, ICE = 3, FIRE = 4, CAVE = 5}
enum BulletType {REGULAR, FIRE}
const BULLET_POOL_SIZE: int = 50

const HERO_DARK: Color = Color(0, 0, 0)
const HERO_LIGHT: Color = Color(1, 1, 1)
const BULLET_REGULAR_DARK: Color = Color(0, 0, 0)
const BULLET_REGULAR_LIGHT: Color = Color(1, 1, 1)
