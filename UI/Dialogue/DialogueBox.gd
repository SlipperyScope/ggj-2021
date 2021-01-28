extends Control

# Characters per second to feed out
export var TextSpeed = 25
export var DialogueText = "This is a sample of some dialogue"

onready var TextBox = $Panel/HBoxContainer/Label

func _ready():
    TextBox.text = ""
    
func PrintText():
    pass