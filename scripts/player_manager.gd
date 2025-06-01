# player_manager.gd
extends Node

var joined_players: Dictionary[int, int] = {}
const MAX_PLAYERS: int = 4

func join_player(controller_id: int) -> int:
	if controller_id in joined_players:
		return -1
	if controller_id in joined_players:
		return joined_players[controller_id]
	if joined_players.size() >= MAX_PLAYERS:
		return -1
	
	var player_id: int = joined_players.size() + 1
	joined_players[controller_id] = player_id
	return player_id

func leave_player(controller_id: int) -> void:
	if controller_id in joined_players:
		joined_players.erase(controller_id)

func reset_players():
	joined_players.clear()
