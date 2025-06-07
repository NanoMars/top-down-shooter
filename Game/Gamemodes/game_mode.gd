# game_mode.gd
extends Node2D
class_name GameMode

@onready var player_character: PackedScene = preload("res://Game/Player/Player.tscn")
@export var finish_scene: NodePath = NodePath("res://MainMenu/main_menu.tscn")

var spawn_points: Dictionary = {}

@export var game_start_delay: float = 1.5
@export var gamemode_ui: PackedScene
var gamemode_ui_instance: Node = null
@export var round_duration: float = 180
var round_time: float
var game_started: bool = false

func _process(delta: float) -> void:
	if game_started:
		round_time = max(0, round_time - delta)
		#print("Round time left:", round_time)	
		if round_time <= 0:
			if finish_scene:
				get_tree().change_scene_to_file(finish_scene)
			else:
				push_error("finish scene fialed to load")

func _ready() -> void:
	round_time = round_duration
	print("game_mode.gd ready")
	gamemode_ui_instance = gamemode_ui.instantiate()
	add_child(gamemode_ui_instance)
	for node in get_tree().get_nodes_in_group("player_spawns"):
		spawn_points[node.player_color] = node
	print("Spawn points:", spawn_points)

	for controller_id in PlayerManager.joined_players:
		var player_id = PlayerManager.joined_players[controller_id]

		if spawn_points.has(player_id - 1):
			spawn_player(game_start_delay, player_id, controller_id)

	await get_tree().create_timer(game_start_delay).timeout
	start_game()


func _on_player_died(controller_id: int, player_id: int, killer_player_id: int) -> void:
	pass

func start_game() -> void:
	game_started = true
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
