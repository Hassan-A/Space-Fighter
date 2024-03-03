extends StaticBody2D


# Called when the node enters the scene tree for the first time.
var player : CharacterBody2D
const SPEED = 300
@export var sprite : AnimatedSprite2D
@export var explodeSound : AudioStreamPlayer
@export var colShape : CollisionShape2D
signal destroyed
signal addScore
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = (player.position - position).normalized()
	position += direction * SPEED * delta

func set_player(p):
	player = p

func _on_visible_on_screen_notifier_2d_screen_exited():
	colShape.disabled = true
	emit_signal("destroyed", self)
	queue_free()

func explode():
	colShape.disabled = true
	sprite.play("Explode")
	explodeSound.play()
	emit_signal("destroyed", self)

func add_score():
	emit_signal("addScore")


func _on_animated_sprite_2d_animation_finished():
	queue_free()
