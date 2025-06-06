# deathmatch.gd
extends GameMode

var player_scores: Dictionary = {}
@export var deathmatch_ui: PackedScene

func _on_player_died(controller_id: int, player_id: int, killer_player_id: int) -> void:
	if killer_player_id != -1:
		if not player_scores.has(killer_player_id):
			player_scores[killer_player_id] = 0
		player_scores[killer_player_id] += 1

	print("Scores: ", player_scores)

	respawn_player(controller_id, player_id)

func _ready() -> void:
	var ui = deathmatch_ui.instantiate()
	
