extends Node2D

onready var Printer = $Printer

func _ready():
	$DialogTrigger.connect("TriggerDialogue", self, "_StartDialogue")

func _StartDialogue():
	Printer.Clear()
	Printer.Start()
