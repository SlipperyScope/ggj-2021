extends Node2D

export (NodePath) var IconPath
onready var Icon: Sprite = get_node("DialogTrigger")

onready var Printer = $Printer
var InTarget = false

func _ready():
	$DialogTrigger.connect("TriggerDialogue", self, "_StartDialogue")

func _StartDialogue():
	Printer.Clear()
	Printer.Start()

func _on_Area2D_body_exited(_body):
	InTarget = false
	Icon.hide()

func _on_Area2D_body_entered(_body):
	InTarget = true
	Icon.show()

func _process(_delta):
	if InTarget && Input.is_action_pressed('ui_accept'): _StartDialogue()
