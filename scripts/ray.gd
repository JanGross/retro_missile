extends Node2D

var colors = {
	"red" : Color(255,0,0, 0.5),
	"green":Color(0,255,0, 0.5)
}
var ray_color = colors.red
func _ready():
	set_process(true)
	
func _process(delta):
	update()
	
func _draw():
	draw_line(get_pos(), get_pos()+Vector2(0,-1) * 10000, ray_color, 2.5)
