extends Area2D

@export var to_region: Constants.RegName

func _ready() -> void:
	body_entered.connect(func(body):
		if body is Hero:
			for ancestor in Utils.get_ancestors(self):
				if ancestor is Region:
					RegionManager.current_region = ancestor
					if DebugTools.print_stuff: print("Current Region was set to ", ancestor.name, ".")
					break

			# We can't free a collider being tested.
			RegionManager.call_deferred("change_region", to_region) 
		)
