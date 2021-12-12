extends Camera2D

export var ZOOM_SENSIBILITY = 0.05

func _physics_process(delta):
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