extends Node2D
var random = RandomNumberGenerator.new()
@export var playerScene : Resource
var astroidCount = 0
var astroidDict : Dictionary
@export var asteroidScene : Resource

func _ready():
	random.randomize()
	playerScene = preload("res://Prefabs/player.tscn")
	asteroidScene = preload("res://Prefabs/asteroid.tscn")
	spawn_player()

func spawn_player():
	var player = playerScene.instantiate()
	player.connect("add_bullet",bullets)
	add_child(player)
	player.position = Vector2(600,400)

func bullets(b):
	add_child(b)

func create_asteroids():
	if(astroidCount < 10):
		var ast = asteroidScene.instantiate()
		astroidDict[ast] = 1
		astroidCount += 1
		add_child(ast)
		var startingPosition := Vector2(0,0)
		if(random.randf() > 0.5):
			startingPosition.x = random.randf_range(0,1152)
			startingPosition.y = 0
		elif(random.randf() > 0.5):
			startingPosition.x = 0
			startingPosition.y = random.randf_range(0,648)
		ast.position = startingPosition
		ast.set_direction(Vector2(random.randf_range(-1,1),random.randf_range(-1,1)))
