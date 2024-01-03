extends Node2D

@export var playerScene : Resource

func _ready():
	playerScene = preload("res://Prefabs/player.tscn")
	spawn_player()

func spawn_player():
	var player = playerScene.instantiate()
	player.connect("add_bullet",bullets)
	add_child(player)
	player.position = Vector2(600,400)

func bullets(b):
	add_child(b)
