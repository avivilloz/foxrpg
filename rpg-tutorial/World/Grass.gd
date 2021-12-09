extends Node2D

const grassEffect = preload("res://Effects/GrassEffect.tscn")

func create_effect(effect):
	var effectScene = effect.instance()
	get_parent().add_child(effectScene)
	effectScene.global_position = global_position

func _on_Hurtbox_area_entered(area:Area2D):
	create_effect(grassEffect)
	queue_free()