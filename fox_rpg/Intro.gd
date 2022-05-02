extends Control

const WorldResource = preload("res://World.tscn")
const ButtonSoundResource = preload("res://ButtonSound.tscn")

func _on_Button_pressed():
	var ButtonSoundScene = ButtonSoundResource.instance()
	add_child(ButtonSoundScene)
	var worldScene = WorldResource.instance()
	get_parent().add_child(worldScene)
	queue_free()