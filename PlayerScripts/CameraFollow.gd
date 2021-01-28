extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():	
	set_as_toplevel(true)

func move_camera(position):
	print("move " + str(position.x) + ", " + str(position.y))
	self.position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
