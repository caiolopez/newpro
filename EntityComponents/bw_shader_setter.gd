extends Node2D

@export var dark_color: Color = Color.BLACK
@export var light_color: Color = Color.WHITE
@onready var parent: Node2D = get_parent()
var mat: ShaderMaterial


func _ready() -> void:
	mat = ShaderMaterial.new()
	mat.shader = load("res://CaioShaders/bw_replacer.gdshader")
	mat.set_shader_parameter("replace_black", dark_color)
	mat.set_shader_parameter("replace_white", light_color)
	parent.material = material
	
