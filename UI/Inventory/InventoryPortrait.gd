extends Control

onready var _TextureBox = $MarginContainer/Portrait

export (Texture) var _Texture
var PortraitTexture: Texture setget _SetTexture

func _ready():
	self.PortraitTexture = _Texture

func _SetTexture(texture):
	_TextureBox.texture = texture
