extends Control

onready var _TextureBox = $MarginContainer/Portrait
onready var _Button = $Button

export (Texture) var _Texture
var PortraitTexture: Texture setget _SetTexture
var PortraitTooltip setget _SetTooltip

func _ready():
	self.PortraitTexture = _Texture

func _SetTexture(texture):
	_TextureBox.texture = texture

func _SetTooltip(tooltip):
	_Button.hint_tooltip = tooltip
