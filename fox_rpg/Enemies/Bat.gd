extends KinematicBody2D

const explodeEffect = preload("res://Effects/ExplodeEffect.tscn")

enum {
	# IDLE,
	WANDER,
	CHASE
}

export var KNOCKBACK_SPEED = 120
export var ACCELERATION = 300
export var MAX_SPEED = 40
export var FRICTION = 200
export var INVINCIBILITY_TIME = 0.3

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE

onready var sprite = $AnimatedSprite
onready var playerDetectionZone = $PlayerDetectionZone
onready var stats = $Stats
onready var hurtbox = $Hurtbox
onready var wanderController = $WanderController
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		# IDLE:
		# 	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		# 	seek_player()

		WANDER:
			seek_player()
			if global_position.distance_to(wanderController.target_position) >= 4: # 4 is just a small number to represent how distant they need to be stop moving
				accelerate_towards_point(wanderController.target_position, delta)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				# state = IDLE
				state = WANDER
				wanderController.start_timer()

	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		wanderController.timer.stop()

func _on_Hurtbox_area_entered(area:Area2D):
	knockback = area.knockback_vector * KNOCKBACK_SPEED
	stats.health -= area.damage
	hurtbox.create_effect()
	hurtbox.start_invincibility(INVINCIBILITY_TIME)

func create_effect():
	var explodeEffectScene = explodeEffect.instance()
	get_parent().add_child(explodeEffectScene)
	explodeEffectScene.global_position = global_position

func _on_Stats_no_health():
	create_effect()
	get_tree().current_scene.get_node("World/CanvasLayer/EnemiesUI").numOfEnemies -= 1
	queue_free()

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
