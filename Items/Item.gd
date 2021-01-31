extends Node
class_name Item



enum ItemTypes{Sword, Shield, Wand, Cloak, Loot, Armor, Potion}

export (ItemTypes) var ItemType 
export var Tooltip = "Tooltip"
export (Texture) var Portrait
export (PackedScene) var World