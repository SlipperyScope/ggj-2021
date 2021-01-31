extends Interactable

export (Item.ItemTypes) var RequiredItem

func _ready():
	$Inventory.RequiredItemType = RequiredItem