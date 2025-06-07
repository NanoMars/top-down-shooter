# game_mode.gd
extends Node2D
class_name GameMode

@onready var player_character: PackedScene = preload("res://Game/Player/Player.tscn")
@export var finish_scene: NodePath = NodePath("res://MainMenu/main_menu.tscn")
@onready var box_spawner_scene: PackedScene = preload("res://Game/BoxSpawner.tscn")

var spawn_points: Dictionary = {}

@export var game_start_delay: float = 1.5
@export var gamemode_ui: PackedScene
var gamemode_ui_instance: Node = null
@export var round_duration: float = 180
@export var box_spawn_goal: int = 7
@export var box_spawn_delay: float = 1
@export var initial_boxes: int = 4
var round_time: float
var game_started: bool = false
var box_timer = 0

func _process(delta: float) -> void:
	if round_time <= 0:
			if finish_scene:
				get_tree().change_scene_to_file(finish_scene)
				return
			else:
				push_error("finish scene fialed to load")

	if get_tree() and game_started:
		round_time = max(0, round_time - delta)
		#print("Round time left:", round_time)	
		
		box_timer += delta
		var crate_nodes = get_tree().get_nodes_in_group("crates")
		var crate_count: int = 0
		if crate_nodes:
			crate_count = crate_nodes.size()

		var spawn_factor = float(crate_count) / float(box_spawn_goal)
		spawn_factor = clamp(spawn_factor, 0.0, 1.0)

		var spawn_delay = box_spawn_delay * pow(3, spawn_factor + 1)

		print("waiting ", spawn_delay, "seconds. current time:", box_timer, "seconds")
		if  box_timer >= spawn_delay:
			var box_spawner_instance = box_spawner_scene.instantiate()
			box_spawner_instance.global_position = Vector2(randf() * 1920, randf() * 1080)
			get_tree().get_nodes_in_group("game_root")[0].add_child(box_spawner_instance)
			box_spawner_instance.spawn_box(1)
			box_timer = 0

		

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

	for i in range(initial_boxes):
		var box_spawner_instance = box_spawner_scene.instantiate()
		box_spawner_instance.global_position = Vector2(randf() * 1920, randf() * 1080)
		get_tree().get_nodes_in_group("game_root")[0].add_child(box_spawner_instance)
		box_spawner_instance.spawn_box(1)

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
