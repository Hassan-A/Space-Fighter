extends CharacterBody2D

const SPEED = 400.0
var direction = Vector2(0,0)
var player : CharacterBody2D
var radius = 500
var angle = 0

func _physics_process(delta):
	angle += SPEED * delta
	var ox = radius * cos(angle) + player.position.x
	var oy = radius * sin(angle) + player.position.y
	var direction = (Vector2(ox, oy) - position).normalized()
	
	velocity = direction * SPEED
	
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if(collision.get_collider().get_collision_layer() == 6 && !is_queued_for_deletion()):
			collision.get_collider().explode()
			collision.get_collider().add_score()

func create(p):
	player = p
