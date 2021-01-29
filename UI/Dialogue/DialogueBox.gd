extends Control

signal DialogueFinished

onready var _Printer = $TextPrinter
onready var _AudioPlayer = $AudioPlayer
onready var _Portrait = $Portrait
onready var _TextBox = $HBoxContainer/MarginContainer/BlurbDisplay/Blurb
onready var _NavUp = $HBoxContainer/MarginContainer/BlurbDisplay/Buttons/Navigate/NavUp
onready var _NavDown = $HBoxContainer/MarginContainer/BlurbDisplay/Buttons/Navigate/NavDown
onready var _Play = $HBoxContainer/MarginContainer/BlurbDisplay/Buttons/Play
onready var _Next = $HBoxContainer/MarginContainer/BlurbDisplay/Buttons/Next

var _Dialogue: Dialogue
var _CurrentBlurb: Blurb
var _Printing = false
var _Audioing = false

func _ready():
	call_deferred("_SetupListeners")

func _SetupListeners():
	_NavUp.connect("pressed", self, "_PreviousBlurb")
	_NavDown.connect("pressed", self, "_NextBlurb")
	_Play.connect("pressed", self, "_PlayBlurb")
	_Next.connect("pressed", self, "_Skip")
	_Printer.connect("PrintComplete", self, "_PrintComplete")
	_Printer.connect("PrintStarted", self, "_PrintStarted")
	_AudioPlayer.connect("finished", self, "_AudioFinished")

func StartDialogue(dialogue: Dialogue):
	_Dialogue = dialogue
	_NextBlurb()

func _AudioStarted():
	_Audioing = true

func _AudioFinished():
	_Audioing = false

func _PrintStarted():
	_Printing = true

func _PrintComplete():
	_Printing = false

func _PreviousBlurb():
	pass

func _NextBlurb():
	_TextBox.text = ""
	if _Dialogue.IsLastBlurb:
		emit_signal("DialogueFinished")
		return
	
	var blurb = _Dialogue.GetNextBlurb()
	_CurrentBlurb = blurb
	_AudioPlayer.stream = blurb.BlurbAudio
	_Printer.Configure(blurb.BlurbText, _CalculateSpeed(blurb.BlurbAudio, blurb.BlurbText))
	_Portrait.texture = blurb.FaceTexture
	_PlayBlurb()
	_Printer.Start()

func _PlayBlurb():
	_AudioPlayer.play()
	_AudioStarted()

func _Skip():
	if _Printing or _Audioing:
		_Printer.Skip()
		_AudioPlayer.stop()
	else:
		_NextBlurb()

func _CalculateSpeed(audio: AudioStreamSample, text: String):
	return text.length() / audio.get_length() - 0.5
