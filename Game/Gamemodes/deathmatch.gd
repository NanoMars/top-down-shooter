# deathmatch.gd
extends GameMode

var player_scores: Dictionary = {}

var boxes_spawned: int = 0

func _on_player_died(controller_id: int, player_id: int, killer_player_id: int) -> void:
	if killer_player_id != -1:
		if not player_scores.has(killer_player_id):
			player_scores[killer_player_id] = 0
		player_scores[killer_player_id] += 1
		gamemode_ui_instance.update_score(killer_player_id, player_scores[killer_player_id])

	respawn_player(controller_id, player_id)

func _ready() -> void:
	super._ready()
	for player_id in PlayerManager.joined_players.values():
		player_scores[player_id] = 0


		
	
