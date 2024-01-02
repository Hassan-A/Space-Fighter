extends CharacterBody2D
const SPEED = 500.0
var direction = Vector2(0,0)
func _physics_process(delta):
	velocity = direction * SPEED
	
	move_and_slide()

func create(dir):
	direction = dir
