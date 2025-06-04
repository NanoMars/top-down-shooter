# game.gd
extends Node2D

@export var player_character: PackedScene

var spawn_points: Dictionary = {}

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("player_spawns"):
		spawn_points[node.player_color] = node

	for controller_id in PlayerManager.joined_players:
		var player_id = PlayerManager.joined_players[controller_id]
		var player_instance = player_character.instantiate()

		player_instance.controller_id = controller_id

		if spawn_points.has(player_id - 1):
			player_instance.global_position = spawn_points[player_id - 1].global_position
		add_child(player_instance)
