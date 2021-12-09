extends KinematicBody2D

const explodeEffect = preload("res://Effects/ExplodeEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

export var KNOCKBACK_SPEED = 120
export var ACCELERATION = 300
export var MAX_SPEED = 40
export var FRICTION = 200

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE

onready var sprite = $AnimatedSprite
onready var playerDetectionZone = $PlayerDetectionZone
onready var stats = $Stats

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()

		WANDER:
			pass

		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION *delta)
			else:
				state = IDLE

			sprite.flip_h = velocity.x < 0

	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area:Area2D):
	knockback = area.knockback_vector * KNOCKBACK_SPEED
	stats.health -= area.damage

func create_effect(effect):
	var effectScene = effect.instance()
	get_parent().add_child(effectScene)
	effectScene.global_position = global_position

func _on_Stats_no_health():
	create_effect(explodeEffect)
	queue_free()
