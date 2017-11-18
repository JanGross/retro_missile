extends StaticBody2D

var state 
var local_health
var missile_scn = preload("res://scenes/missile.tscn")
var states = {"STATE_AIMING": StateAiming, "STATE_FIRING": StateFiring}
var cannon_rotation = 90
var cannon_rot_dir = 0
export var health = 100
export var reload_time = 0.8

signal state_change

func _ready():
	set_state("STATE_AIMING")
	set_process_input(true)
	set_process(true)
	local_health = health

func _process(delta):
	state.update(delta)
	
func _fixed_process(delta):
	if state.has_method("fixed_update"):
		state.fixed_process(delta)
	
func _input(event):
	print(event.type)
	if state.has_method("input"):
		state.input(event)

func damage(dmg):
	local_health -= dmg
	if local_health <= 0 and not game_manager.state == game_manager.STATE_GAMEOVER:
		game_manager.game_over()

func set_state(new_state):
	if state: state._exit()
	emit_signal("state_change", self, new_state)
	print("State change to %s" % new_state)
	var new_state_instance = states[new_state].new(self)
	self.state = new_state_instance
	

func get_state():
	return state.to_string()
	
class StateFiring:
	func to_string():
		return "STATE_FIRING"
	var base
	var missile_spawn
	var missile_rot
	func _init(_base):
		self.base = _base
		missile_spawn = base.get_node("CannonSprite/CannonTip")
		missile_rot = base.get_node("CannonSprite").get_global_rot()

	func update(delta):
		shoot_missile()

	func shoot_missile():
		var missile = base.missile_scn.instance()
		missile.init(base)
		base.add_child(missile)
		missile.set_global_rot(missile_rot)
		missile.set_global_pos(missile_spawn.get_global_pos())
		print("Fired")
		base.set_state("STATE_AIMING")

		
	func _exit():
		pass
		
class StateAiming:
	func to_string():
		return "STATE_AIMING"
	var base
	var cannon
	var ray
	var reload_timer
	func _init(_base):
		self.base = _base
		reload_timer = base.reload_time
		cannon = base.get_node("CannonSprite")
		ray = cannon.get_node("Ray")
		
	func update(delta):
		if reload_timer > 0: 
			reload_timer -= delta
			ray.ray_color = ray.colors.red
		else: ray.ray_color = ray.colors.green
		#var mouse_pos = base.get_global_mouse_pos()
		#cannon.look_at(mouse_pos)
		#cannon.set_rot(cannon.get_global_pos().angle_to_point(mouse_pos))
	
	func fixed_process(delta):
		base.cannon_rotation += base.cannon_rot_dir
		cannon.set_rot(deg2rad(base.cannon_rotation))
	
	func input(event):
		if event.is_action_pressed("slow_motion"):
			OS.set_time_scale(0.15)
		if event.is_action_released("fire") or event.is_action_released("A") and reload_timer <= 0:
			print("We fire")
			base.set_state("STATE_FIRING")
		if event.is_action("ui_left") or event.is_action("J_left"):
			base.cannon_rot_dir = 1 
		if event.is_action("ui_right") or event.is_action("J_right"):
			base.cannon_rot_dir = -1
		if event.is_action_released("ui_right") or event.is_action_released("ui_left") or event.is_action_released("J_right") or event.is_action_released("J_left"):
			base.cannon_rot_dir = 0
		
	func _exit():
		pass
	