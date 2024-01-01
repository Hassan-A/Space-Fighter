extends CharacterBody2D

const SPEED = 20
var degree = 0
var xDirection = 1
var yDirection = -1

func _physics_process(delta):
	var direction = Vector2(0,0)
	
	var rot = Input.get_axis("ui_left", "ui_right")
	if rot:
		rotate(deg_to_rad(2 * rot))
		degree = int(rotation_degrees + 360) % 360
		if(degree > 270):
			degree -= 270
			degree = 90 - degree
			xDirection = -1
			yDirection = -1
		elif(degree > 180):
			degree -= 180
			xDirection = -1
			yDirection = 1
		elif(degree > 90):
			degree -= 90
			degree = 90 - degree
			xDirection = 1
			yDirection = 1
		else:
			xDirection = 1
			yDirection = -1
	
	if Input.is_action_pressed("ui_up"):
		direction = Vector2(0,-1)
	velocity = direction * SPEED
	move_and_slide()
