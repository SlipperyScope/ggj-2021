extends Control

func _ready():
	_ReadyInventory()
	_ReadyDialogue()

### INVENTORY ###

onready var _InventoryItems = $InventoryItems

export (NodePath) var _InventoryPath
onready var _Inventory = get_node(_InventoryPath)

export var ItemSize = 128

func _ReadyInventory():
	ClearInventoryHUD()
	_Inventory.connect("InventoryUpdated", self, "UpdateInventoryHUD")

func UpdateInventoryHUD(items):
	ClearInventoryHUD()
	for item in items:
		var hudItem = TextureRect.new()
		hudItem.texture = item.Portrait
		hudItem.expand = true
		hudItem.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		hudItem.rect_min_size = Vector2(ItemSize, ItemSize)
		hudItem.hint_tooltip = item.Tooltip
		hudItem.mouse_filter = 0
		hudItem.size_flags_horizontal = 0
		hudItem.size_flags_vertical = 0
		_InventoryItems.add_child(hudItem)

func ClearInventoryHUD():
	for hudItem in _InventoryItems.get_children():
		_InventoryItems.remove_child(hudItem)
		hudItem.queue_free()

### DIALOGUE ###

signal DialogueFinished

onready var _Printer = $TextPrinter
onready var _Player = $AudioStreamPlayer
onready var _Portrait = $Portrait
onready var _Textbox = $DialogueBox/Contents/Textuality/Textbox
onready var _Name = $DialogueBox/Contents/Textuality/NameBox/Name
onready var _NavUp = $DialogueBox/Contents/Buttons/NavUp
onready var _NavDown = $DialogueBox/Contents/Buttons/NavDown
onready var _Proceed = $DialogueBox/Contents/Buttons/Proceed
onready var _BlurbBox = $BlurbBox
onready var _DialogueBox = $DialogueBox

var _Dialogue: Dialogue
var _Blurb: Blurb
var _Printing = false
var _Playing = false

func _ReadyDialogue():
	_NavUp.connect("pressed", self, "_NavUpPressed")
	_NavDown.connect("pressed", self, "_NavDownPressed")
	#_Replay.connect("pressed", self, "_ReplayPressed")
	_Proceed.connect("pressed", self, "_ProceedPressed")
	_Printer.connect("PrintStarted", self, "_PrintStarted")
	_Printer.connect("PrintComplete", self, "_PrintComplete")
	_Player.connect("finished", self, "_AudioComplete")
	ClearBlurb()
	_DialogueBox.visible = false
	_BlurbBox.visible = false
	_Portrait.visible = false

func StartDialogue(dialogue: Dialogue):
	_Dialogue = dialogue
	_Dialogue.Heard = true
	_DialogueBox.visible = true
	_BlurbBox.visible = true
	_Portrait.visible = true
	_NextBlurb()
	
func StopDialogue():
	ClearBlurb()
	_DialogueBox.visible = false
	_BlurbBox.visible = false
	_Portrait.visible = false
	_Dialogue.Reset(true)
	emit_signal("DialogueFinished")
		
func _NextBlurb():
	_Proceed.disabled = false
	ClearBlurb()
	if !_Dialogue.IsLastBlurb:
		ChangeBlurb(_Dialogue.GetNextBlurb())
		StartBlurb()

func ChangeBlurb(blurb: Blurb):
	ClearBlurb()
	_Blurb = blurb
	_Player.stream = blurb.BlurbAudio
	_Printer.Configure(blurb.BlurbText, _CalculatePrintSpeed(blurb))
	_Portrait.texture = blurb.FaceTexture
	_Name.text = blurb.CharacterName
	_UpdateButton()

func ClearBlurb():
	_Portrait.texture = null
	_Textbox.text = ""
	if _Player.playing:
		_Player.stop()
	if _Printer.Printing:
		_Printer.Skip()
	_Playing = false
	_Printing = false
	#_Proceed.disabled = true
	_Name.text = "UNKNOWN"
	_Blurb = null

func StartBlurb():
	if !_Blurb.Played:
		if !_Blurb.NoAudio:
			_Player.play()
			_AudioStarted()
		_Printer.Start()
	else:
		_Printer.Skip()
		_AudioComplete()

func _NavUpPressed():
	#print("NavUp")
	ChangeBlurb(_Dialogue.GetPreviousBlurb())
	StartBlurb()

func _NavDownPressed():
	#print("NavDown")
	ChangeBlurb(_Dialogue.GetNextBlurb())
	StartBlurb()

func _ProceedPressed():
	if _Printing:
		if !_Dialogue.ForceStart: _Printer.Skip()
	if _Playing:
		if !_Dialogue.ForceStart: _Player.stop()
	elif _Dialogue.IsLastBlurb:
		StopDialogue()
		#_UpdateButton()
	else:
		_NextBlurb()

func _ReplayPressed():
	_Player.start()
	_AudioStarted()

func _PrintStarted():
	_Printing = true

func _PrintComplete():
	_Printing = false
	_TagBlurb()
	
func _AudioStarted():
	_Playing = true

func _AudioComplete():
	_Playing = false
	_TagBlurb()

func _TagBlurb():
	if !_Playing and !_Printing and !_Blurb.Played:
		_UpdateButton()
		_Blurb.Played = true

func _UpdateButton():
	_NavUp.disabled = _Dialogue.IsFirstBlurb
	_NavDown.disabled = _Dialogue.IsLastBlurb || !_Blurb.Played

func _CalculatePrintSpeed(blurb):
	if blurb.NoAudio:
		return blurb.DefaultTextSpeed
	return blurb.BlurbText.length() / blurb.BlurbAudio.get_length()
