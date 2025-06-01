# player_menu.gd
extends Node

@export var player_section: PackedScene


func _input(event):
	if event is InputEventJoypadButton and event.pressed:
		var player_id: int = PlayerManager.join_player()
		if player_id != -1:
			var section: Control = player_section.instantiate()
			section.controller_id = player_id
			add_child(section)
		else:
			print("Maximum players reached, cannot join more.")
