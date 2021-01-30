extends Node
class_name Dialogue

var _Blurbs = []

var BlurbCount = 0
var CurrentIndex = -1
var CurrentBlurb: Blurb
var IsLastBlurb = false
var IsFirstBlurb = false

export (bool) var ForceStart = false

func _ready():
	for blurb in get_children():
		if blurb is Blurb:
			_Blurbs.append(blurb)
			BlurbCount += 1
	
func GetNextBlurb() -> Blurb:
	if IsLastBlurb:
		return null
	CurrentIndex += 1
	_UpdateBlurbEnds()
	return _Blurbs[CurrentIndex]

func GetPreviousBlurb() -> Blurb:
	if IsFirstBlurb:
		return null
	CurrentIndex -= 1
	_UpdateBlurbEnds()
	return _Blurbs[CurrentIndex]
	
func _UpdateBlurbEnds():
	IsLastBlurb = false
	IsFirstBlurb = false
	if CurrentIndex == _Blurbs.size() - 1:
		IsLastBlurb = true
	if CurrentIndex == 0:
		IsFirstBlurb = true
