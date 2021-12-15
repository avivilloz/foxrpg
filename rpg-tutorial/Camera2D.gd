extends Camera2D

export var ZOOM_SENSIBILITY = 0.05

onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x

func _physics_process(_delta):
	var x = zoom.x 
	var y = zoom.y
	if Input.is_action_pressed("zoom in"):
		x -= ZOOM_SENSIBILITY
		y -= ZOOM_SENSIBILITY
	if Input.is_action_pressed("zoom out"):
		x += ZOOM_SENSIBILITY
		y += ZOOM_SENSIBILITY

	if x >= 1 && x <= 2 && y >= 1 && y <= 2:
		zoom.x = x
		zoom.y = y