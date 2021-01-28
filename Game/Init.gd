extends Node

export (PackedScene) var MainMenu

func _ready():
	get_tree().change_scene_to(MainMenu)