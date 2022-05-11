extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500
export var ROLL_SPEED = 120
export var ATTACK_WALK_SPEED = 20
export var INVINCIBILITY_TIME = 0.6

enum {
	MOVE,
	ROLL,
	ATTACK
}

var stats = PlayerStats
var state = MOVE
var velocity = Vector2.ZERO
var action_vector = Vector2.DOWN

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $Position2D/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = action_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

		ROLL:
			roll_state(delta)

		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		action_vector = input_vector
		swordHitbox.knockback_vector = input_vector

		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)

		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move()

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

	if Input.is_action_just_pressed("roll"):
		state = ROLL

func move():
	velocity = move_and_slide(velocity)

func roll_state(_delta):
	animationState.travel("Roll")
	velocity = action_vector * ROLL_SPEED
	move()

func roll_animation_finished():
	state = MOVE

func attack_state(_delta):
	# velocity = Vector2.ZERO
	animationState.travel("Attack")
	velocity = action_vector * ATTACK_WALK_SPEED
	move()

func attack_animation_finished():
	state = MOVE

func _on_Hurtbox_area_entered(area:Area2D):
	stats.health -= area.damage
	hurtbox.start_invincibility(INVINCIBILITY_TIME)
	hurtbox.create_effect()
	create_hurt_sound()

func create_hurt_sound():
	var hurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(hurtSound)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")