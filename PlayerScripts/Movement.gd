extends KinematicBody2D

export (int) var speed = 200
onready var HUD = $CanvasLayer/HUD
onready var Steve: AnimatedSprite = get_node("Steve")
onready var _Inventory = get_node("Inventory")

var velocity = Vector2()
var Interactor
var DialogueBoxWorking = false

var ProgressBits = {
	"Arrows": 2,
	"Lava": 3,
	"Pit": 4,
	"Imp": 5,
	"Web": 6,
	"Spell": 7,
	"MetalDetector": 8,
	"MagicDetector": 9,
}

func _ready():
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
				elif Interactor.InteractionType == Interactable.Interaction.Putdown: _place_item()
		elif Input.is_action_pressed('ui_accept') && !$Horn.playing: $Horn.play()

func _on_Area2D_area_entered(_area):
	if _area.get_parent() == null or (_area.get_parent() is Interactable) == false:
		return

	Interactor = _area.get_parent()
	if Interactor.InteractionType == Interactable.Interaction.Pickup: _add_items()

	if Interactor.has_node("Node2D/Notification"):
		Interactor.get_node("Node2D/Notification").play("NotificationAnimation")

	if Interactor is Interactable and Interactor.InteractionType == Interactable.Interaction.Dialogue:
		_start_dialogue(true)

func _on_Area2D_area_exited(_area):
	if Interactor != null:
		if Interactor.has_node("Node2D/Notification"): Interactor.get_node("Node2D/Notification").stop()
		Interactor = null

func _start_dialogue(forced := false):
	if Interactor.has_node("NoCloakDialogue") && !_Inventory.HasItem(Item.ItemTypes.Cloak): return imp_dialogue()
	if !forced && Interactor.has_node("DialogueJobsDone") && _Inventory.Items.size() == 0: return _actually_play_dialogue(Interactor.get_node("DialogueJobsDone"))

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
	Interactor.get_node("Node2D/Notification").queue_free()
	Interactor.get_node("Node2D/NotiSprite").queue_free()

	update_progression_triggers()

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
			Interactor.get_node("Node2D/Notification").queue_free()
			Interactor.get_node("Node2D/NotiSprite").queue_free()
			break

	update_progression_triggers()

func update_progression_triggers():
	set_collision_layer_bit(ProgressBits["Arrows"], !_Inventory.HasItem(Item.ItemTypes.Shield))
	set_collision_layer_bit(ProgressBits["Lava"], !_Inventory.HasItem(Item.ItemTypes.Potion))
	set_collision_layer_bit(ProgressBits["Pit"], !_Inventory.HasItem(Item.ItemTypes.Armor))
	set_collision_layer_bit(ProgressBits["Imp"], !_Inventory.HasItem(Item.ItemTypes.Cloak))
	set_collision_layer_bit(ProgressBits["Web"], !_Inventory.HasItem(Item.ItemTypes.Sword))
	set_collision_layer_bit(ProgressBits["Spell"], !_Inventory.HasItem(Item.ItemTypes.Wand))
	set_collision_layer_bit(
		ProgressBits["MetalDetector"],
		_Inventory.HasAnyItemType([Item.ItemTypes.Shield, Item.ItemTypes.Sword, Item.ItemTypes.Loot])
	)
	set_collision_layer_bit(
		ProgressBits["MagicDetector"],
		_Inventory.HasAnyItemType([Item.ItemTypes.Cloak, Item.ItemTypes.Wand, Item.ItemTypes.Armor, Item.ItemTypes.Potion])
	)
