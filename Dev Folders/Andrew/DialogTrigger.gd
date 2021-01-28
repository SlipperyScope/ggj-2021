extends Sprite

signal TriggerDialogue

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click"):
		emit_signal("TriggerDialogue")



