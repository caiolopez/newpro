class_name Region extends Node2D


func _ready():
	RegionManager.set_current_region(self)
