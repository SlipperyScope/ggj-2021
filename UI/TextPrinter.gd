extends Node
class_name TextPrinter

signal PrintStarted
signal PrintComplete
signal PrintProgress
signal PrinterReset

# Text box to use
export (NodePath) var TextBoxPath
onready var _Textbox: RichTextLabel = get_node(TextBoxPath)

# Characters per second to print
export var PrintSpeed = 20.0

# Message to print
export var Message = ""

var _PrintTimer: Timer
var _CurrentIndex = -1

func _init():
	_MakeTimer()

func Configure(message, speed):
	Message = message
	PrintSpeed = speed

func Start(from: int = 0):
	_CurrentIndex = from
	emit_signal("PrintStarted")
	_PrintNext()
	_PrintTimer.start(1.0 / PrintSpeed)
	pass

func Skip():
	_PrintTimer.stop()
	_CurrentIndex = Message.count() - 1
	_Textbox.text = Message
	emit_signal("PrintComplete")

func Reset():
	_PrintTimer.stop()
	_CurrentIndex = -1
	Message = ""
	PrintSpeed = 20.0
	emit_signal("PrinterReset")

func _PrintNext(finish := true):
	if _CurrentIndex < Message.length():
		_Textbox.text += Message[_CurrentIndex]
		emit_signal("PrintProgress")
		_CurrentIndex += 1
		if _CurrentIndex == Message.length():
			emit_signal("PrintComplete")
		if finish:
			_PrintTimer.start(1.0 / PrintSpeed)

func _MakeTimer():
	_PrintTimer = Timer.new()
	_PrintTimer.one_shot = true
	add_child(_PrintTimer)
	var __ = _PrintTimer.connect("timeout", self, "_PrintNext")
