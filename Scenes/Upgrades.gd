extends Control

var random = RandomNumberGenerator.new()
@export var timer : Timer
@export var ul1 : Label
@export var ul2 : Label
@export var ul3 : Label
@export var selection : TextureRect
var labelArray : Array
var currentSelection : int = 0: 
	set(v):
		currentSelection = v
		currentSelection %= 3
		selection.reparent(labelArray[currentSelection],false)
var upgrades = ["Add Time", "Increase Speed", "Upgrade Bullet", "Add Weapon"]
signal upgraded

var player : CharacterBody2D
func set_player(p):
	player = p

func _ready():
	labelArray = [ul1,ul2,ul3]
	random.randomize()

func set_upgrades():
	var upgradeChoices : Array = upgrades.duplicate()
	var currentUpgrades = []
	for n in range(3):
		var r = random.randi_range(0,upgradeChoices.size()-1)
		currentUpgrades.push_back(upgradeChoices[r])
		upgradeChoices.remove_at(r)
	
	ul1.text = currentUpgrades[0]
	ul2.text = currentUpgrades[1]
	ul3.text = currentUpgrades[2]

func _input(event):
	if event.is_action_pressed("ui_up"):
		currentSelection -= 1
	if event.is_action_pressed("ui_down"):
		currentSelection += 1
	if event.is_action_pressed("ui_select"):
		#do upgrade
		if(labelArray[currentSelection].text == "Add Time"):
			timer.start(timer.time_left + 20)
		elif(labelArray[currentSelection].text == "Increase Time"):
			player.SPEED += 100
		elif(labelArray[currentSelection].text == "Upgrade Bullet"):
			player.upgradeBullet()
		elif(labelArray[currentSelection].text == "Add Weapon"):
			player.activateWeapon()
		emit_signal("upgraded")
