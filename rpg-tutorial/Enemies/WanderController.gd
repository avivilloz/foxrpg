extends Node2D

export(int) var WANDER_RANGE = 32
export(int) var CHANGE_DIRECTION_TIME = 1

onready var start_position = get_parent().global_position
onready var target_position = get_parent().global_position

onready var timer = $Timer

func _ready():
	update_target_position()

func start_timer():
	timer.start(CHANGE_DIRECTION_TIME)

func update_target_position():
	var target_vector = Vector2(rand_range(-WANDER_RANGE, WANDER_RANGE), rand_range(-WANDER_RANGE, WANDER_RANGE))
	target_position = start_position + target_vector

func _on_Timer_timeout():
	update_target_position()
