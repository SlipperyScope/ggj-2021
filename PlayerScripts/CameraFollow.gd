extends Camera2D

func move_camera(position):
	var newPos = self.position
	if position.x - 100 > self.position.x: newPos.x = position.x - 100
	if position.x + 100 < self.position.x: newPos.x = position.x + 100
	if position.y - 50 > self.position.y: newPos.y = position.y - 50
	if position.y + 50 < self.position.y: newPos.y = position.y + 50
	self.position = newPos

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
