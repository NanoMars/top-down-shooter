# player_menu.gd
extends Node

@export var player_section: PackedScene


func _input(event):
	if event is InputEventJoypadButton and event.pressed:
		var controller_id: int = event.device
		var player_id: int = PlayerManager.join_player(controller_id)
		if player_id != -1:
			var section: Control = player_section.instantiate()
			section.controller_id = controller_id
			section.player_id = player_id
			add_child(section)
