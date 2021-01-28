extends Button

# #Which scene to load when the button is pressed
export (PackedScene) var SceneToLoad

func _on_Button_pressed():
	get_tree().change_scene_to(SceneToLoad)
