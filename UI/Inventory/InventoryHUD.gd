extends MarginContainer

export (NodePath) var _InventoryPath
onready var _Inventory = get_node(_InventoryPath)
export (PackedScene) var ItemScene
onready var _ItemsContainer = $Items

func _ready():
	Clear()
	_Inventory.connect("InventoryUpdated", self, "RefreshItems")

func RefreshItems(items):
	Clear()
	for item in items:
		var portrait = ItemScene.instance()
		_ItemsContainer.add_child(portrait)
		portrait.PortraitTexture = item.Portrait
		portrait.hint_tooltip = item.Tooltip

func Clear():
	var portraits = _ItemsContainer.get_children()
	for portrait in portraits:
		_ItemsContainer.remove_child(portrait)
		portrait.queue_free()
