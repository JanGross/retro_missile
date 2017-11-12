extends Node
const STATE_STARTUP = 0
const STATE_PLAYING = 1
const STATE_GAMEOVER = 2
const STAGE_TIME = 30
var active_asteroids = 0
var stage = 1
var total_time = 0
var slowmo_time = 5
var score = 0
var time_next_stage = 25
var state = STATE_STARTUP
func _ready():
	set_fixed_process(true)
	update_ui()
	
func game_over():
	state = STATE_GAMEOVER
	var restart_btn = game_manager.get_node_from_root("Node/UI/Restart")
	restart_btn.show()
	restart_btn.get_node("AnimationPlayer").connect("finished", self, "game_over_ts")
	restart_btn.get_node("AnimationPlayer").play("anim_in")
func game_over_ts():
	OS.set_time_scale(0.03)
	
func reset():
	get_tree().reload_current_scene()
	stage = 1
	active_asteroids = 0
	total_time = 0
	slowmo_time = 0
	score = 0
	time_next_stage = 25
	OS.set_time_scale(1)
	state = STATE_PLAYING
	update_ui()
	
func get_node_from_root(node_name):
	return get_tree().get_root().get_node(node_name)
	
func _fixed_process(delta):
	total_time += delta
	if not state == STATE_GAMEOVER: slowmo_update(delta)
	stage_update(delta)
	
func stage_update(delta):
	time_next_stage -= delta
	if time_next_stage <= 0:
		get_node_from_root("Node/WorldAudio").play("level_up")
		stage += 1
		update_ui()
		time_next_stage = STAGE_TIME
		
func slowmo_update(delta):
	if slowmo_time >= 0: 
		slowmo_time -= delta / OS.get_time_scale()
	else: set_slowmo(false)
	if OS.get_time_scale() != 1.0: get_node_from_root("Node/UI/SlowmoBar").update_value(slowmo_time)

func set_slowmo(slowmo, time=5, scale=0.5):
	if slowmo:
		slowmo_time = time
		OS.set_time_scale(scale)
		get_node_from_root("Node/UI/SlowmoBar").set_max_val(time)
	else:
		OS.set_time_scale(1)
		
func update_ui():
	var health = get_node_from_root("Node/Base").local_health
	get_node_from_root("Node/UI/ScoreLabel").update_text(stage, active_asteroids, health)
	
func get_active_asteroids():
	return active_asteroids
	
func add_asteroid():
	active_asteroids += 1
	update_ui()
	if active_asteroids > stage + 7:
		game_manager.set_slowmo(true, 15, 0.2)
	elif active_asteroids > stage + 5:
		game_manager.set_slowmo(true, 10, 0.25)
	elif active_asteroids > stage + 3:
		game_manager.set_slowmo(true, 10, 0.5)
func remove_asteroid():
	active_asteroids -= 1
	update_ui()
