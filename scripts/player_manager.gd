# player_manager.gd
extends Node

var joined_players: Dictionary[int, int] = {}
const MAX_PLAYERS: int = 4
signal player_id_changed(controller_id: int, player_id: int)

func join_player(controller_id: int) -> int:
	if controller_id in joined_players:
		return -1
	if controller_id in joined_players:
		return joined_players[controller_id]
	if joined_players.size() >= MAX_PLAYERS:
		return -1
	
	var player_id: int = joined_players.size() + 1
	joined_players[controller_id] = player_id
	emit_signal("player_id_changed", controller_id, player_id)
	print("Player joined: Controller ID ", controller_id, " as Player ID ", player_id)
	return player_id

func leave_player(controller_id: int) -> void:
	if controller_id in joined_players:
		var leaving_player_id: int = joined_players[controller_id]
		print("Player left: Controller ID ", controller_id, " as Player ID ", joined_players[controller_id])	
		joined_players.erase(controller_id)

		for cid in joined_players.keys():
			if joined_players[cid] > leaving_player_id:
				joined_players[cid] -= 1
				emit_signal("player_id_changed", cid, joined_players[cid])
func reset_players():
	joined_players.clear()
