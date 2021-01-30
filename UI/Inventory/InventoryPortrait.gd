extends Control

signal Clicked

onready var _TextureBox = $MarginContainer/Portrait
onready var _Button = $Button

export (Texture) var _Texture
var PortraitTexture: Texture setget _SetTexture

func _ready():
	self.PortraitTexture = _Texture

func _SetTexture(texture):
	_TextureBox.texture = texture

func _gui_input(event):
	if event.is_action_pressed("Click"):
		emit_signal("Clicked")
