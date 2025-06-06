# game_mode.gd
extends Node2D
class_name GameMode

@onready var player_character: PackedScene = preload("res://Game/Player/Player.tscn")

var spawn_points: Dictionary = {}

@export var game_start_delay: float = 1.5

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("player_spawns"):
		spawn_points[node.player_color] = node

	for controller_id in PlayerManager.joined_players:
		var player_id = PlayerManager.joined_players[controller_id]

		if spawn_points.has(player_id - 1):
			spawn_player(game_start_delay, player_id, controller_id)

	await get_tree().create_timer(game_start_delay).timeout
	start_game()


func _on_player_died(controller_id: int, player_id: int, killer_player_id: int) -> void:
	pass

func start_game() -> void:
	print("Game started")
	pass

func spawn_player(time: float, player_id: int, controller_id: int):
	var player = await spawn_points[player_id - 1].spawn_player(time, player_id, controller_id)
	player.died.connect(_on_player_died)

func respawn_player(controller_id: int, player_id: int):
	var spawn_point = spawn_points[player_id - 1]
	if spawn_point:
		var player = await spawn_point.spawn_player(3, player_id, controller_id)
		player.died.connect(_on_player_died)
