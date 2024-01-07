extends Node2D

@export var menu : Control
@export var background : Sprite2D
@export var playerScene : Resource
@export var asteroidScene : Resource
var player : CharacterBody2D
var random = RandomNumberGenerator.new()
var astroidCount = 0
var astroidDict : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	playerScene = preload("res://Prefabs/player.tscn")
	asteroidScene = preload("res://Prefabs/asteroid.tscn")
	start_menu()

func start_menu():
	set_process(false)
	set_visiblity(menu,true)
	set_visiblity(background, false)

func _on_texture_button_button_up():
	start_game()

func set_visiblity(node,visiblity):
	node.visible = visiblity

func start_game():
	set_visiblity(background, true)
	set_visiblity(menu,false)
	spawn_player()
	set_process(true)

func spawn_player():
	player = playerScene.instantiate()
	player.connect("add_bullet",bullets)
	add_child(player)
	player.position = Vector2(600,400)

func bullets(b):
	add_child(b)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	create_asteroids()

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
		ast.connect("destroyed", asteroidGone)

func asteroidGone(ast):
	astroidDict.erase(ast)
	astroidCount -= 1

