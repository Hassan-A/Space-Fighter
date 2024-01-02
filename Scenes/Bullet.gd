extends CharacterBody2D
const SPEED = 500.0
var direction = Vector2(0,0)

func _physics_process(_delta):
	velocity = direction * SPEED
	print("move bullet ", velocity)
	move_and_slide()

func create(dir):
	direction = dir

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
