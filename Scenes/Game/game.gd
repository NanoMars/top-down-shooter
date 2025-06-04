# game.gd
extends Node2D

@export var player_character: PackedScene

var spawn_points: Dictionary = {}

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("player_spawns"):
		spawn_points[node.player_color] = node

	for controller_id in PlayerManager.joined_players:
		var player_id = PlayerManager.joined_players[controller_id]

		if spawn_points.has(player_id - 1):
			spawn_player(1.5, player_id, controller_id)

func _on_player_died(controller_id: int, player_id: int) -> void:
	var spawn_point = spawn_points[player_id - 1]
	if spawn_point:
		var player = await spawn_point.spawn_player(3, player_id, controller_id)
		player.died.connect(_on_player_died)

func spawn_player(time: float, player_id: int, controller_id: int):
	var player = await spawn_points[player_id - 1].spawn_player(time, player_id, controller_id)
	player.died.connect(_on_player_died)
