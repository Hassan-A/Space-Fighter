extends StaticBody2D

# Called when the node enters the scene tree for the first time.
var direction = Vector2(0,0)
const SPEED = 150.0
@export var sprite : AnimatedSprite2D
signal destroyed
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + direction * SPEED * delta

func set_direction(new_direction):
	direction = new_direction

func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("destroyed", self)
	queue_free()

func explode():
	sprite.play("Explode")
	emit_signal("destroyed", self)

func _on_animated_sprite_2d_animation_finished():
	queue_free()
