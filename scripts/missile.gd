extends KinematicBody2D

export var speed_mult = 100
var speed = Vector2(0,-1)
var origin
var exploded = false

func init(_origin):
	randomize()
	origin = _origin
	speed = speed * speed_mult

func _ready():
	#OS.set_time_scale(0.21)
	get_node("Audio").play("missile_launch")
	set_process(true)
	get_node("CollisionArea").connect("area_enter", self, "_on_collision")
	randomize()
	
func _process(delta):
	move_forward(delta)
	if origin: check_bounds()
	if exploded and not get_node("Audio").is_voice_active(2): queue_free()
	
func move_forward(delta):
	move(speed.rotated(get_rot())*delta)
	
func _on_collision(other):
	if other.get_owner().has_method("on_rocket_hit"):
		other.get_owner().on_rocket_hit()
		var explosion_audio = "explosion_%s" % ceil(rand_range(1, 5))
		print("Playing %s" % explosion_audio)
		get_node("Audio").play(explosion_audio, 2)
		print("target destroyed")
		hide()
		get_node("CollisionArea").queue_free()
		exploded = true
	
func check_bounds():
	var origin_pos = origin.get_global_pos()
	var max_dist = origin_pos.distance_to(Vector2(0,0))
	var current_dist = get_global_pos().distance_to(origin_pos)
	if current_dist > max_dist:
		print("Missile out of bounds")
		queue_free()
	
	
