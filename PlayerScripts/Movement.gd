extends KinematicBody2D

export (int) var speed = 200
onready var DialogueBox = $DialogueBox
onready var Steve: AnimatedSprite = get_node("Steve")
onready var _Inventory = get_node("Inventory")

var velocity = Vector2()
#var Dialogue
var Interactor
var DialogueBoxWorking = false

func _ready():
	DialogueBox.connect("DialogueFinished", self, "_print_finished")

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('p_right'):
		velocity.x += 1
	if Input.is_action_pressed('p_left'):
		velocity.x -= 1
	if Input.is_action_pressed('p_down'):
		velocity.y += 1
	if Input.is_action_pressed('p_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	if (!DialogueBoxWorking):
		get_input()
		velocity = move_and_slide(velocity)
		if velocity.length() > 0 : 
			Steve.animation = "walk"
			if velocity.x < 0: Steve.flip_h = true
			else: Steve.flip_h = false
		else: Steve.animation = "idle"

func _process(_delta):
	if (!DialogueBoxWorking && Interactor):
		if Input.is_action_pressed('ui_accept'):
			if Interactor.has_node("Dialogue"): _start_dialogue()
			elif Interactor.has_node("Item"): _add_item()
			#if dialogue else if item->Inventory.AddItem() else if....

func _on_Area2D_area_entered(_area):
	Interactor = _area.get_node("../")
	if Interactor.has_node("Notification"):
		Interactor.get_node("Notification").show()#do a little dance

	if Interactor.has_node("Dialogue"): 
		var Dialogue = Interactor.get_node("Dialogue")
		if Dialogue.ForceStart: _start_dialogue()

func _on_Area2D_area_exited(_area):
	if Interactor != null:
		if Interactor.has_node("Notification"): Interactor.get_node("Notification").hide() #stop a little dance
		Interactor = null

func _start_dialogue():
	DialogueBox.StartDialogue(Interactor.get_node("Dialogue"))
	DialogueBoxWorking = true

func _print_finished():
	DialogueBoxWorking = false

func _add_item():
	_Inventory.AddItem(Interactor.get_node("Item"))
	Interactor.queue_free()
	#remove Interactor
