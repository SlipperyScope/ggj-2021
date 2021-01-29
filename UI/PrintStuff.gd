extends Node2D

onready var Icon: Sprite = get_node("DialogTrigger")

export (bool) var ForceStart = false

onready var Printer = $Printer
var InTarget = false
var PrinterReady = true

func _ready():
	Printer.connect("PrintComplete", self, "_SetReady")

func _SetReady():
	PrinterReady = true
	if InTarget: Icon.show()

func _StartDialogue():
	PrinterReady = false
	Icon.hide()
	Printer.Clear()
	Printer.Start()

func _on_Area2D_body_exited(_body):
	InTarget = false
	Icon.hide()

func _on_Area2D_body_entered(_body):
	InTarget = true
	if ForceStart: _StartDialogue()
	else: Icon.show()

func _process(_delta):
	if PrinterReady && InTarget && Input.is_action_pressed('ui_accept'): _StartDialogue()
