extends CharacterBody2D

const SPEED = 20

func _physics_process(delta):
	var direction = Vector2(0,0)
	
	if Input.is_action_pressed("ui_up"):
		direction = Vector2(0,-1)
	velocity = direction * SPEED
	move_and_slide()
