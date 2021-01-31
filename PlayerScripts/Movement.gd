extends KinematicBody2D

export (int) var speed = 200
onready var HUD = $CanvasLayer/HUD
onready var Steve: AnimatedSprite = get_node("Steve")
onready var _Inventory = get_node("Inventory")

var velocity = Vector2()
var Interactor
var DialogueBoxWorking = false

func _ready():
	pass
	HUD.connect("DialogueFinished", self, "_print_finished")

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
			elif velocity.x > 0: Steve.flip_h = false
		else: Steve.animation = "idle"

func _process(_delta):
	if (!DialogueBoxWorking && Interactor):
		if Input.is_action_pressed('ui_accept'):
			if Interactor.has_node("Dialogue"): _start_dialogue()
			elif Interactor.has_node("TakeMe"): _add_items()
			elif Interactor.has_node("Inventory"): _place_item()

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
	HUD.StartDialogue(Interactor.get_node("Dialogue"))
	Steve.animation = "idle"
	DialogueBoxWorking = true

func _print_finished():
	DialogueBoxWorking = false

func _add_items():
	for item in Interactor.get_node("TakeMe").get_children():
		if item is Item:
			_Inventory.AddItem(item, false)

	Interactor.get_node("TakeMe").queue_free()
	Interactor.get_node("Notification").queue_free()

func _place_item():
	var destInventory = Interactor.get_node("Inventory")
	if !destInventory.SpecificItem: return

	var requiredType = destInventory.RequiredItemType
	var _placed = false

	for item in _Inventory.Items:
		if item.ItemType == requiredType:
			destInventory.AddItem(item, false)
			_Inventory.RemoveItem(item, false)
			destInventory.RequiredItemType = null
			_placed = true
	
	#do something with placed
