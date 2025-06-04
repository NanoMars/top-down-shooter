extends Node

var red := Color("#FC5C65")
var purple := Color("#9179FF")
var yellow := Color("#FFB601")
var green := Color("#38D98B")

func get_colour(index: int) -> Color:
	match index:
		0: return red
		1: return purple
		2: return yellow
		3: return green
		_: return red