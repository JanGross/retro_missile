extends Sprite
	
var ttl = 4

func _ready():
	set_process(true)
	get_node("AnimationPlayer").connect("finished", self, "anim_finished")
	get_node("ExplosionArea").connect("body_enter", self, "on_collision")

func anim_finished():
	get_node("ExplosionArea").queue_free()
	
func on_collision(other):
	if other != null and other.has_method("on_rocket_hit"):
			other.on_rocket_hit()
			print("R ON R")

func _process(delta):
	if ttl <= 0:
		get_parent().queue_free()
	else: ttl -= delta
