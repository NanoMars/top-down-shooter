# player_manager.gd
extends Node

var joined_players: Dictionary[int, int] = {}

func join_player(controller_id: int) -> int:
	var player_id: int = -1
	if joined_players.is_empty():
		player_id = 0
	else:
		player_id = joined_players.size()
	joined_players.append(player_id)
	return player_id

# func leave_player(player_id: int):
# 	if player_id in joined_players:
# 		joined_players.erase(player_id)

# func reset_players():
# 	joined_players.clear()
# 	current_controllers.clear()