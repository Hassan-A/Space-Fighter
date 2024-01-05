extends CharacterBody2D
const SPEED = 500.0
var direction = Vector2(0,0)

func _physics_process(_delta):
	velocity = direction * SPEED
	print("move bullet ", velocity)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if(collision.get_collider().get_collision_layer() == 6 && !is_queued_for_deletion()):
			collision.get_collider().explode()
			collision.get_collider().add_score()
			queue_free()

func create(dir):
	direction = dir

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
