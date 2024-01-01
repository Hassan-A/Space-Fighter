extends CharacterBody2D

func _physics_process(delta):
	var direction = Vector2(0,0)
	
	if Input.is_action_pressed("ui_up"):
		direction = Vector2(0,-1)
	velocity = direction * 10
	move_and_slide()
