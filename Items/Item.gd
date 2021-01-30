extends Node
class_name Item

enum ItemTypes{Eggplant, CoolHat}

export (ItemTypes) var ItemType 
export var Tooltip = "Tooltip"
export (Texture) var Portrait
export (PackedScene) var World