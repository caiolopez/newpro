@icon("res://EditorIcons/region_icon.svg")
class_name Region extends Node

@export var default_checkpoint_trigger: CheckpointTrigger = null ## When to information regarding checkpoints is provided, this will be the starting checkpoint. Use this for the first checkpoint of the game.
@export var REGION_COLOR_THEME_FG:Array[Color] = [Color("3f160b"), Color("f67f00")]
@export var REGION_COLOR_THEME_BG:Array[Color] = [Color("3f160b"), Color("f67f00")]
