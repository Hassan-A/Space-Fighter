extends CharacterBody2D
const SPEED = 100.0
var direction = Vector2(0,0)

func _ready():
	print("ready")

func _enter_tree():
	print("init")

func _process(_delta):
	print("process")

func _physics_process(_delta):
	velocity = direction * SPEED
	print("move bullet ", velocity)
	move_and_slide()

func create(dir):
	print("bullet created")
	direction = dir
