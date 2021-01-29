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
	_NavUp.disabled = true
	_NavDown.disabled = true
	_Play.disabled = true
	_Next.disabled = true
	visible = false
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
	_Next.disabled = false
	_NextBlurb()
	visible = true

func _AudioStarted():
	_Audioing = true

func _AudioFinished():
	_Audioing = false

func _PrintStarted():
	_Printing = true

func _PrintComplete():
	_Printing = false

func _PreviousBlurb():
	_TextBox.text = ""
	if _Dialogue.IsFirstBlurb:
		return

	_ChangeBlurb(_Dialogue.GetPreviousBlurb())

func _NextBlurb():
	_TextBox.text = ""
	if _Dialogue.IsLastBlurb:
		return
	
	_ChangeBlurb(_Dialogue.GetNextBlurb())

func _ChangeBlurb(blurb):
	if _CurrentBlurb != null && _CurrentBlurb != null:
		_CurrentBlurb.Played = true

	_CurrentBlurb = blurb
	_AudioPlayer.stream = blurb.BlurbAudio

	_Printer.Configure(blurb.BlurbText, _CalculateSpeed(blurb.BlurbAudio, blurb.BlurbText))
	_Portrait.texture = blurb.FaceTexture
	_UpdateButtons()

	_PlayBlurb()
	_Printer.Start()

func _ClearBlurb():
	_TextBox.text = ""
	_Printer.Skip()
	_AudioPlayer.stop()

func _FinishDialogue():
	emit_signal("DialogueFinished")
	visible = false

func _PlayBlurb():
	_AudioPlayer.play()
	_AudioStarted()

func _Skip():
	if _Printing or _Audioing:
		_Printer.Skip()
		_AudioPlayer.stop()
	elif _Dialogue.IsLastBlurb:
		_FinishDialogue()
	else:
		_NextBlurb()

func _UpdateButtons():
	_NavDown.disabled = _Dialogue.IsLastBlurb || !_CurrentBlurb.Played
	_NavUp.disabled = _Dialogue.IsFirstBlurb || _CurrentBlurb.Played

func _CalculateSpeed(audio: AudioStreamSample, text: String):
	return text.length() / (audio.get_length() - 1)
