# player_section.gd
extends Control

var controller_id: int = -1
var player_id: int = -1
var loaded: bool = false

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
