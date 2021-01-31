extends Control

export (PackedScene) var Level

func _ready():
	($TextureButton).connect("pressed", self, "ChangeScene")

func ChangeScene():
	get_tree().change_scene_to(Level)
