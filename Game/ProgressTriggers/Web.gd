extends StaticBody2D

signal DoSomething

func _ready():
	pass
	connect("DoSomething", self, "Do")

func Do():
	queue_free()