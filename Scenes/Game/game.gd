# game.gd
extends Node2D

@export var player_character: PackedScene

@export var red_spawn: Marker2D
@export var purple_spawn: Marker2D
@export var yellow_spawn: Marker2D
@export var green_spawn: Marker2D

func _ready() -> void:
	for controller_id in PlayerManager.joined_players:
		var player_id = PlayerManager.joined_players[controller_id]
		var player_instance = player_character.instantiate()

		player_instance.controller_id = controller_id

		match player_id:
			1:
				player_instance.position = red_spawn.global_position
			2:
				player_instance.position = purple_spawn.global_position
			3:
				player_instance.position = yellow_spawn.global_position
			4:
				player_instance.position = green_spawn.global_position
		add_child(player_instance)
