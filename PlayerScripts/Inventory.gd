extends Node

signal InventoryItemAdded(item)
signal InventoryItemRemoved(item)
signal InventoryUpdated(items)

export (bool) var SpecificItem = true
export (Item.ItemTypes) var RequiredItemType 

var Items = []

func _ready():
	call_deferred("_DeferReady")
	
func _DeferReady():
	for child in get_children():
		if child is Item:
			AddItem(child, false)

func AddItem(item, autoAddChild := true):
	Items.append(item)
	item.get_parent().remove_child(item)
	add_child(item, false)
	emit_signal("InventoryItemAdded", item)
	emit_signal("InventoryUpdated", Items)
	if autoAddChild:
		add_child(item, false)

func RemoveItem(item, autoRemoveChild := true) -> bool:
	var index = Items.find(item)
	if index == -1:
		return false

	var removedItem = Items[index]
	Items.remove(index)
	emit_signal("InventoryItemRemoved", removedItem)
	emit_signal("InventoryUpdated", Items)

	if autoRemoveChild:
		remove_child(item)
	return true

func HasItem(item):
	for i in Items:
		if i.ItemType == item || i == item:
			return true
	
	return false

func GetItem(type) -> Item:
	for item in Items:
		if item.ItemType == type:
			return item
	return null

func Transfer(otherInventory, item):
	otherInventory.RemoveItem(item)
	AddItem(item)