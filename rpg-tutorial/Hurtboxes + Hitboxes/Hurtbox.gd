extends Area2D

const hitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincibility

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincibility(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false

func create_effect():
	var hitEffectScene = hitEffect.instance()
	get_parent().add_child(hitEffectScene)
	hitEffectScene.global_position = global_position

func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring", false)

func _on_Hurtbox_invincibility_ended():
	monitoring = true