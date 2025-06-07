extends PanelContainer

@onready var game_root: Node2D = get_tree().get_nodes_in_group("game_root")[0]
@export var time_label: Label

func _process(delta: float) -> void:
	var round_time = game_root.round_time
	var minutes = int(round_time / 60)
	var seconds = int(fmod(round_time, 60.0))
	var time_string = "%02d:%02d" % [minutes, seconds]
	if time_label:
		time_label.text = time_string
