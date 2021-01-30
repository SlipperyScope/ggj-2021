extends Node

signal InventoryItemAdded(item)
signal InventoryItemRemoved(item)
signal InventoryUpdated(items)

var Items = []

func _ready():
	for child in get_children():
		if child is Item:
			AddItem(child)

func AddItem(item):
	Items.append(item)
	emit_signal("InventoryItemAdded", item)
	emit_signal("InventoryUpdated", Items)

func RemoveItem(item) -> bool:
	var index = Items.find(item)
	if index == -1:
		return false

	var removedItem = Items[index]
	Items.remove(index)
	emit_signal("InventoryItemRemoved", removedItem)
	emit_signal("InventoryUpdated")
	return true

func HasItem(item):
	return Items.find(item) != -1
