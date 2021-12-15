extends Control

var numOfEnemies

onready var label = $Label

func _ready():
	var enemies : Array = get_tree().current_scene.get_node("World/YSort/Enemies").get_children()
	numOfEnemies = enemies.size()

func _physics_process(_delta):
	label.text = "Enemies: " + str(numOfEnemies)
