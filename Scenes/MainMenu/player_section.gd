# player_section.gd
extends Control

var controller_id: int = -1
var player_id: int = -1
var loaded: bool = false

var spring_velocity: float = 0.0

@export var spring_strength: float = 0.9
@export var spring_dampening: float = 0.2

@export var player_label: Label

func _process(_delta: float) -> void:
	if controller_id == -1 or player_id == -1:
		return
	
	if not loaded and controller_id != -1 and player_id != -1:
		loaded = true
		player_label.text = "Player " + str(player_id)
		

	if Input.is_joy_button_pressed(controller_id, JOY_BUTTON_A):
		print("start game")
	elif Input.is_joy_button_pressed(controller_id, JOY_BUTTON_B):
		PlayerManager.leave_player(controller_id)

func _physics_process(delta: float) -> void:
	spring_velocity += (1 - size_flags_stretch_ratio) * spring_strength * delta
	spring_velocity -= spring_velocity * spring_dampening * delta
	size_flags_stretch_ratio += spring_velocity * delta

	print("Spring velocity: ", spring_velocity)
	print("Size flags stretch ratio: ", size_flags_stretch_ratio)
