# player_section.gd
extends Control

var controller_id: int = -1

func _process(_delta: float) -> void:
	if controller_id == -1:
		return
	
	if Input.is_joy_button_pressed(controller_id, JOY_BUTTON_A):
		print("start game")
	elif Input.is_joy_button_pressed(controller_id, JOY_BUTTON_B):
		PlayerManager.leave_player(controller_id)
