extends Control

func _ready():
	_ReadyInventory()
	_ReadyDialogue()

### INVENTORY ###

onready var _InventoryItems = $InventoryItems

export (NodePath) var _InventoryPath
onready var _Inventory = get_node(_InventoryPath)

export var ItemSize = 128

func _ReadyInventory():
	ClearInventoryHUD()
	_Inventory.connect("InventoryUpdated", self, "UpdateInventoryHUD")

func UpdateInventoryHUD(items):
	ClearInventoryHUD()
	for item in items:
		var hudItem = TextureRect.new()
		hudItem.texture = item.Portrait
		hudItem.expand = true
		hudItem.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		hudItem.rect_min_size = Vector2(ItemSize, ItemSize)
		hudItem.hint_tooltip = item.Tooltip
		hudItem.mouse_filter = 0
		hudItem.size_flags_horizontal = 0
		hudItem.size_flags_vertical = 0
		_InventoryItems.add_child(hudItem)

func ClearInventoryHUD():
	for hudItem in _InventoryItems.get_children():
		_InventoryItems.remove_child(hudItem)
		hudItem.queue_free()

### DIALOGUE ###

func _ReadyDialogue():
	pass
