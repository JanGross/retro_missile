extends KinematicBody2D

var explosion = preload("res://scenes/explosion.tscn")
var velocity = Vector2()
export var speed_min = 10
export var speed_max = 50

func _ready():
	randomize()
	var rand_x = rand_range(0, get_viewport_rect().size.width)
	set_global_pos(Vector2(rand_x, rand_range(-5, -60))) #random offset for easy "random timing"
	
	rand_x = rand_range(0, get_viewport_rect().size.width)
	var target = Vector2(rand_x, get_viewport_rect().size.height)
	
	set_rot(get_global_pos().angle_to_point(target)+deg2rad(180))
	velocity = Vector2(0, rand_range(speed_min, speed_max))
	get_node("Sprite").set_rotd(rand_range(0,360))
	set_process(true)

func _process(delta):
	move(velocity.rotated(get_rot())*delta)
	check_bounds()
	
func check_bounds():
	if get_pos().y > get_viewport_rect().size.y - 5:
		print("Asteroid out of bounds")
		game_manager.get_node_from_root("Node/Base").damage(10)
		destroy()
	
func destroy():
	get_node("CollisionArea").queue_free()
	game_manager.remove_asteroid()
	var new_explosion = explosion.instance()
	new_explosion.set_pos(get_pos())
	game_manager.get_node_from_root("Node").add_child(new_explosion)
	queue_free()

func on_rocket_hit():
	destroy()