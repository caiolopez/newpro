class_name Region extends Node2D

func _ready() -> void:
	pass
	if not RegionManager.current_region:
		RegionManager.set_current_region(self)
