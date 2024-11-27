class_name BwShaderSetter extends Node

@export var dark_color: Color = Color.BLACK ## The color that will replace the black pixels. Note: Is overwritten by "Dark Color Name".
@export var dark_color_name: StringName ## The name of the constant bearing the desired color value, as implemented in the Constants file. This has priority over the color picker value.
@export var light_color: Color = Color.WHITE ## The color that will replace the white pixels. Note: Is overwritten by "Light Color Name".
@export var light_color_name: StringName ## The name of the constant bearing the desired color value, as implemented in the Constants file. This has priority over the color picker value.
@export var transparency: float = 0.0
@onready var parent: Node2D = get_parent()
var mat: ShaderMaterial

func _ready() -> void:
	mat = ShaderMaterial.new()
	mat.shader = load("res://CaioShaders/bw_replacer.gdshader")
	parent.material = mat
	_update_color()

func _update_color() -> void:
	if not mat: return
	if Constants.get(dark_color_name):
		dark_color = Constants.get(dark_color_name)
	if Constants.get(light_color_name):
		light_color = Constants.get(light_color_name)
	mat.set_shader_parameter("replace_black", dark_color)
	mat.set_shader_parameter("replace_white", light_color)
	mat.set_shader_parameter("transparency", transparency)

func set_color(dark: Color, light: Color):
	dark_color_name = &""
	light_color_name = &""
	dark_color = dark
	light_color = light
	_update_color()

func set_color_pair(color_pair: Array[Color]):
	dark_color_name = &""
	light_color_name = &""
	dark_color = color_pair[0]
	light_color = color_pair[1]
	_update_color()

func get_color() -> Array[Color]:
	return [dark_color, light_color]
