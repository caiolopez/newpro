extends _Background

func _on_entity_died(_entity: Node):
	AppManager.camera.shake()
	pass
