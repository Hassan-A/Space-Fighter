extends Node2D

@export var objectsParent : Node2D
@export var menu : Control
@export var endDisplay : Control
@export var background : Sprite2D
@export var timer : Timer
@export var spawnTimer : Timer
@export var spawnTimer2 : Timer
@export var timerLabel : Label
@export var scoreLabel : Label
@export var endScoreLabel : Label
@export var inGameLabels : Control
@export var upgradesUI : Control
@export var progress : ProgressBar
@export var playSound : AudioStreamPlayer
@export var backgroundSound : AudioStreamPlayer
@export var spaceShipMoveSound : AudioStreamPlayer
@export var spaceShipFireSound : AudioStreamPlayer
@export var playerScene : Resource
@export var asteroidScene : Resource
@export var enemy1 : Resource
@export var enemy2 : Resource
@export var initialTime : int = 60

var player : CharacterBody2D
var random = RandomNumberGenerator.new()
var score = 0
var scoreArray : Array
var astroidCount = 0
var astroidDict : Dictionary
var experience : int = 0:
	set(v): 
		experience = v
		progress.value = experience

# Called when the node enters the scene tree for the first time.
func _ready():
	upgradesUI.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	upgradesUI.connect("upgraded",has_upgraded)
	random.randomize()
	playerScene = preload("res://Prefabs/player.tscn")
	asteroidScene = preload("res://Prefabs/asteroid.tscn")
	enemy1 = preload("res://Prefabs/enemy1.tscn")
	enemy2 = preload("res://Prefabs/enemy2.tscn")
	start_menu()

func start_menu():
	scoreArray = [84,62,112,9]
	set_process(false)
	set_visiblity(menu,true)
	set_visiblity(endDisplay, false)
	set_visiblity(background, false)
	set_visiblity(scoreLabel, false)
	set_visiblity(timerLabel, false)
	set_visiblity(inGameLabels, false)
	set_visiblity(upgradesUI, false)
	score = 0
	experience = 0

func _on_texture_button_button_up():
	playSound.play()
	start_game()

func set_visiblity(node,visiblity):
	node.visible = visiblity

func start_game():
	backgroundSound.play()
	set_visiblity(timerLabel,true)
	set_visiblity(background, true)
	set_visiblity(menu,false)
	set_visiblity(scoreLabel,true)
	set_visiblity(timerLabel,true)
	set_visiblity(inGameLabels, true)
	timer.start(initialTime)
	spawnTimer.start(10)
	spawnTimer2.start(30)
	spawn_player()
	set_process(true)
	upgradesUI.set_player(player)
	astCount = 5
	spawnCount = 1
	e2SpawnCount = 1

func spawn_player():
	player = playerScene.instantiate()
	player.connect("game_over",game_over)
	player.connect("add_bullet",bullets)
	objectsParent.add_child(player)
	player.position = Vector2(600,400)

func bullets(b):
	objectsParent.add_child(b)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	change_texts()
	create_asteroids()

func change_texts():
	timerLabel.text = "Time: " + str(int(timer.time_left))
	scoreLabel.text = "Score: " + str(score)

var astCount = 5
func create_asteroids():
	if(astroidCount < astCount):
		var ast = asteroidScene.instantiate()
		astroidDict[ast] = 1
		astroidCount += 1
		objectsParent.add_child(ast)
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
		ast.connect("addScore", add_score)

var spawnCount = 1
func _on_spawn_timer_timeout():
	for i in range(spawnCount):
		var ast = enemy1.instantiate()
		astroidDict[ast] = 1
		astroidCount += 1
		objectsParent.add_child(ast)
		var startingPosition := Vector2(50,50)
		if(random.randf() > 0.5):
			startingPosition.x = random.randf_range(0,1152)
			startingPosition.y = 0
		elif(random.randf() > 0.5):
			startingPosition.x = 0
			startingPosition.y = random.randf_range(0,648)
		ast.position = startingPosition
		ast.set_player(player)
		ast.connect("destroyed", asteroidGone)
		ast.connect("addScore", add_score)
	spawnCount += 2
	astCount += 3

var e2SpawnCount = 1
func _on_2_spawn_timer_timeout():
	for i in range(e2SpawnCount):
		var ast = enemy2.instantiate()
		astroidDict[ast] = 1
		astroidCount += 1
		objectsParent.add_child(ast)
		var startingPosition := Vector2(50,50)
		if(random.randf() > 0.5):
			startingPosition.x = random.randf_range(0,1152)
			startingPosition.y = 0
		elif(random.randf() > 0.5):
			startingPosition.x = 0
			startingPosition.y = random.randf_range(0,648)
		ast.position = startingPosition
		ast.set_player(player)
		ast.connect("destroyed", asteroidGone)
		ast.connect("addScore", add_score)
	e2SpawnCount += 1

func asteroidGone(ast):
	astroidDict.erase(ast)
	astroidCount -= 1

func add_score():
	score += 1
	add_exp()

func add_exp():
	experience += 1
	if(experience == 10):
		upgradesUI.set_upgrades()
		set_visiblity(upgradesUI, true)
		experience = 0
		pause_game(true)
		

func has_upgraded():
	set_visiblity(upgradesUI, false)
	pause_game(false)

func pause_game(setting):
	get_tree().paused = setting

func _on_timer_timeout():
	game_over()

func game_over():
	spawnTimer.stop()
	spawnTimer2.stop()
	timer.stop()
	set_process(false)
	scoreArray.append(score)
	setHighScores()
	set_visiblity(endDisplay,true)
	set_visiblity(inGameLabels,false)
	
	player.get_child(1).set_deferred("disabled",true)
	player.destroy_weapons()
	for ast in astroidDict:
		ast.queue_free()
		astroidCount -= 1
	player.queue_free()
	astroidDict.clear()

func setHighScores():
	scoreArray.sort()
	scoreArray.reverse()
	var scorelist = endDisplay.find_children("scoreT*")
	for i in range(scoreArray.size()):
		if(i >= 10):
			break
		scorelist[i].text = " " + str(scoreArray[i])


func _on_gomenu_button_up():
	playSound.play()
	backgroundSound.stop()
	start_menu()


func _on_background_music_finished():
	backgroundSound.play()


