extends Node2D

const grassEffect = preload("res://Effects/GrassEffect.tscn")

func create_effect():
	var grassEffectScene = grassEffect.instance()
	get_parent().add_child(grassEffectScene)
	grassEffectScene.global_position = global_position

func _on_Hurtbox_area_entered(area:Area2D):
	create_effect()
	queue_free()