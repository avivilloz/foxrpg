extends Area2D

export(bool) var show_hit = false

const hitEffect = preload("res://Effects/HitEffect.tscn")

func create_effect(effect):
	var effectScene = effect.instance()
	get_parent().add_child(effectScene)
	effectScene.global_position = global_position

func _on_Hurtbox_area_entered(area:Area2D):
	if show_hit:
		create_effect(hitEffect)