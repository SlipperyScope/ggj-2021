extends Area2D

export (NodePath) var Sprite
export (Item.ItemTypes) var RequiredItem
onready var _Sprite = get_node(Sprite)

func on_SpriteRemover_body_entered(body):
	if body.get_parent()._Inventory.HasItem(RequiredItem):
		_Sprite.visible = false