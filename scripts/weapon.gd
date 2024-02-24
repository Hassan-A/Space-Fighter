extends CharacterBody2D

const SPEED = 200.0
var direction = Vector2(0,0)
var player : CharacterBody2D
var radius = 100
var angle = 0

func _physics_process(delta):
	velocity = direction * SPEED
	angle += SPEED * delta
	var orbit_x = radius * cos(angle) + player.position.x
	var orbit_y = radius * sin(angle) + player.position.y
	var orbit_position = Vector2(orbit_x, orbit_y)
	var direction = (orbit_position - position).normalized()
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if(collision.get_collider().get_collision_layer() == 6 && !is_queued_for_deletion()):
			collision.get_collider().explode()
			collision.get_collider().add_score()
			queue_free()

func create(p):
	player = p
