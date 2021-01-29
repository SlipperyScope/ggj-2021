extends Node2D

onready var DialogueBox = $DialogueBox

func _ready():
	$DialogTrigger.connect("TriggerDialogue", self, "_StartDialogue")

func _StartDialogue():
	DialogueBox.StartDialogue($Dialogue)
