extends CharacterBody2D
var bulletSceen : PackedScene
const SPEED = 10.0
var degree = 0
var xDirection = 1
var yDirection = -1
signal game_over
signal add_bullet

func _ready():
	bulletSceen = preload("res://Prefabs/bullet.tscn")
func _physics_process(delta):
	# Handle Jump.
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
		var moveInX = sin(deg_to_rad(degree)) * xDirection
		var moveInY = cos(deg_to_rad(degree)) * yDirection
		direction = Vector2(moveInX,moveInY)
	
	if Input.is_action_just_pressed("ui_accept"):
		#instatiate bullet
		var b = bulletSceen.instantiate()
		emit_signal("add_bullet",b)
		b.position = position
		b.rotation = rotation
		var moveInX = sin(deg_to_rad(degree)) * xDirection
		var moveInY = cos(deg_to_rad(degree)) * yDirection
		var d = Vector2(moveInX,moveInY)
		b.create(d)
		#play sound
	
	velocity = (velocity * 0.9) + direction * SPEED
	
	if((velocity.x < 1 and velocity.x > -1) and (velocity.y < 1 and velocity.y > -1)):
		velocity *= 0
		
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if(collision.get_collider().get_collision_layer() == 6):
			collision.get_collider().explode()
			emit_signal("game_over")
			break
