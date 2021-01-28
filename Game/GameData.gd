extends Node

# Seconds since game started
var GameTime = 0

# Seconds since game started per physics process
var PhysicsGameTime = 0

func _process(delta):
	GameTime += delta

func _physics_process(delta):
	PhysicsGameTime += delta