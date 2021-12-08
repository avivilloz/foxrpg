extends Node2D

# func _process(delta):
# 	if Input.is_action_just_pressed("attack"):

func create_grass_effect():
	var animationResource = load("res://Effects/GrassEffect.tscn")
	var animationScene = animationResource.instance()
	var world = get_tree().current_scene
	animationScene.global_position = global_position
	world.add_child(animationScene)

func _on_Hurtbox_area_entered(area:Area2D):
	create_grass_effect()
	queue_free()