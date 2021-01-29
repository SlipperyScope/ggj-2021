extends Camera2D

export (NodePath) var BackgroundSprite = null

# Immediately set the limit dimensions of the camera to the bounding box
# of the BackgroundSprite. This makes the camera stop following the character
# when the character approaches the edge of the level and prevents showing
# the vast nothingness beneath the BG sprite.
func _ready():
	var sprite : Sprite = get_node(BackgroundSprite)
	var rect : Rect2 = sprite.get_rect()

	limit_left = int(rect.position.x * sprite.scale.x)
	limit_top = int(rect.position.y * sprite.scale.y)
	limit_right = int(rect.end.x * sprite.scale.x)
	limit_bottom = int(rect.end.y * sprite.scale.y)
