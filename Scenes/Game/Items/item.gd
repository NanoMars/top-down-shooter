# item.gd
extends RigidBody2D
class_name Item

var is_held := false

func _ready():
	update_state()

func set_held_state(held: bool):
	is_held = held
	update_state()

func update_state():
	if is_held:
		PhysicsServer2D.body_set_mode(get_rid(), PhysicsServer2D.BODY_MODE_STATIC)
		collision_layer = 0
		collision_mask = 0
		sleeping = true
	else:
		PhysicsServer2D.body_set_mode(get_rid(), PhysicsServer2D.BODY_MODE_RIGID)
		collision_layer = 1
		collision_mask = 1
		sleeping = false

func press(obstacle_distance: float):
	pass

func press_held(delta: float, obstacle_distance: float):
	pass
	
func release(obstacle_distance: float):
	pass