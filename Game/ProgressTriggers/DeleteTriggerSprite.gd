extends Area2D
class_name SpriteRemover

export (NodePath) var Trigger
export (Item.ItemTypes) var RequiredItem
onready var _Trigger = get_node(Trigger)

func _on_SpriteRemover_area_entered(body):
	if body.get_parent()._Inventory.HasItem(RequiredItem):
	#	_Trigger.emit_signal("DoSomething")
		_Trigger.visible = false
