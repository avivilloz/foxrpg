extends Control

onready var m_srcWorldScene = preload("res://world/World.tscn")

func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	var nodeWorldScene = m_srcWorldScene.instance()
	get_parent().add_child(nodeWorldScene)
	queue_free()