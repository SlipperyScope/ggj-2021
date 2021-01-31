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
	if !DialogueBoxWorking:
		if Interactor:
			if Input.is_action_pressed('ui_accept'):
				if Interactor.InteractionType == Interactable.Interaction.Dialogue: _start_dialogue()
				elif Interactor.InteractionType == Interactable.Interaction.Pickup: _add_items()
				elif Interactor.InteractionType == Interactable.Interaction.Putdown: _place_item()
		elif Input.is_action_pressed('ui_accept') && !$Horn.playing: $Horn.play()

func _on_Area2D_area_entered(_area):
	Interactor = _area.get_parent()
	if Interactor.has_node("Notification"):
		Interactor.get_node("Notification").play("NotificationAnimation")

	if Interactor.InteractionType == Interactable.Interaction.Dialogue: 
		_start_dialogue(true)

func _on_Area2D_area_exited(_area):
	if Interactor != null:
		if Interactor.has_node("Notification"): Interactor.get_node("Notification").stop()
		Interactor = null

func _start_dialogue(forced := false):
	if Interactor.has_node("NoCloakDialogue") && !_Inventory.HasItem(Item.ItemTypes.Cloak): return imp_dialogue()
	for item in Interactor.get_children():
		if "NoCloak" in item.name: continue
		if item is Dialogue && (!forced || item.ForceStart):
			if item.FirstOnly:
				if !item.Heard: 
					_actually_play_dialogue(item)
					break
			else: 
				_actually_play_dialogue(item)
				break

func imp_dialogue():
	var noCloak = Interactor.get_node("NoCloakDialogueFirst")
	if noCloak.FirstOnly && !noCloak.Heard: _actually_play_dialogue(noCloak)
	else: _actually_play_dialogue(Interactor.get_node("NoCloakDialogue"))

func _actually_play_dialogue(playThis):
	HUD.StartDialogue(playThis)
	Steve.animation = "idle"
	DialogueBoxWorking = true

func _print_finished():
	DialogueBoxWorking = false

func _add_items():
	for item in Interactor.get_node("Inventory").get_children():
		if item is Item:
			_Inventory.AddItem(item, false)

	Interactor.InteractionType = Interactable.Interaction.None
	Interactor.get_node("Notification").queue_free()
	Interactor.get_node("NotiSprite").queue_free()

func _place_item():
	var destInventory = Interactor.get_node("Inventory")
	if !destInventory.SpecificItem: return

	var requiredType = destInventory.RequiredItemType

	for item in _Inventory.Items:
		if item.ItemType == requiredType:
			destInventory.AddItem(item, false)
			_Inventory.RemoveItem(item, false)
			destInventory.RequiredItemType = null
			Interactor.InteractionType = Interactable.Interaction.None
			Interactor.get_node("Notification").queue_free()
			Interactor.get_node("NotiSprite").queue_free()
			break
	
