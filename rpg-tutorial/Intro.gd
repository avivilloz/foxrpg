extends Control

const WorldResource = preload("res://World.tscn")

func _on_Button_pressed():
	var worldScene = WorldResource.instance()
	get_parent().add_child(worldScene)
	queue_free()
