extends KinematicBody2D

export (int) var speed = 200
onready var DialogueBox = $DialogueBox
onready var Steve: AnimatedSprite = get_node("Steve")

var velocity = Vector2()
var Dialogue
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
	if (!DialogueBoxWorking):
		if Input.is_action_pressed('ui_accept') && Dialogue != null: _start_dialogue()

func _on_Area2D_area_entered(area):
	if area.has_node("../Dialogue"): 
		Dialogue = area.get_node("../Dialogue")
		if Dialogue.ForceStart: _start_dialogue()
		else: area.get_node("../Notification").show()

func _on_Area2D_area_exited(area):
	if area.has_node("../Dialogue"): Dialogue = null
	if area.has_node("../Notification"): area.get_node("../Notification").hide()

func _start_dialogue():
	DialogueBox.StartDialogue(Dialogue)
	DialogueBoxWorking = true

func _print_finished():
	DialogueBoxWorking = false
