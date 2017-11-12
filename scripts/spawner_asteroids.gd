extends Node

const WAVE_TIME = 12
onready var asteroid_scn = preload("res://scenes/asteroid.tscn")
export var amount = 2
var timer = 5

func _ready():
	set_process(true)
	
	
func _process(delta):
	if game_manager.state == game_manager.STATE_GAMEOVER: return
	timer -= delta 
	if timer <= 0:
		for i in range(amount + game_manager.stage):
			spawn_asteroid()
		timer = WAVE_TIME
	
func spawn_asteroid():
	var new_asteroid = asteroid_scn.instance()
	add_child(new_asteroid)
	game_manager.add_asteroid()