extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered", self, "Slide")

func Slide(area):
	$AnimationPlayer.current_animation = "slideover"
	$AnimationPlayer.play()