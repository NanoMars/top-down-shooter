# player.gd
extends CharacterBody2D
var controller_id: int = -1
const DEADZONE := 0.1

var current_item: Node = null

var item_marker: Marker2D 

var dropped_items: Array = []

@export var movement_speed := 200.0
@export var acceleration := 1000.0
@export var friction := 500.0

@export var use_button: int = JOY_AXIS_TRIGGER_RIGHT
@export var drop_button: int = JOY_BUTTON_B

@export var pick_up_collision_shape: CollisionShape2D

@export var drop_impulse_strength: float = 300.0

var holding_use := false
var holding_drop := false

func _ready() -> void:
	item_marker = $Marker2D

func _physics_process(delta):
	# Movement and aiming
	var move_input: Vector2 = Vector2(
		Input.get_joy_axis(controller_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(controller_id, JOY_AXIS_LEFT_Y)
	)
	if move_input.length() > DEADZONE:
		velocity = velocity.move_toward(
			move_input.normalized() * movement_speed,
			acceleration * delta
		)
	else:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			friction * delta
		)

	move_and_slide()

	var aim_input: Vector2 = Vector2(
		Input.get_joy_axis(controller_id, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(controller_id, JOY_AXIS_RIGHT_Y)
	)
	if aim_input.length() > DEADZONE:
		rotation = aim_input.angle()

	# Item interaction

	if Input.get_joy_axis(controller_id, use_button) > 0.5:
		if current_item:
			if not holding_use :
				current_item.press()
			current_item.press_held(delta)
		holding_use = true
	else:
		if current_item and holding_use:
			current_item.release()
		holding_use = false

	if Input.is_joy_button_pressed(controller_id, drop_button):
		if current_item and not holding_drop:
			drop_item()
		holding_drop = true
	else:
		holding_drop = false

func _process(_delta: float) -> void:
	for item in dropped_items:
		if item.global_position.distance_to(global_position) > pick_up_collision_shape.shape.get_radius():
			dropped_items.erase(item)
			break

func _on_body_entered(body: Node):
	if current_item == null and body is Item and not dropped_items.has(body):
		pick_up_item(body)

func pick_up_item(item: Node):
	current_item = item
	call_deferred("_finalize_pick_up", item)

func _finalize_pick_up(item: Node):
	item.get_parent().remove_child(item)
	item_marker.add_child(item)
	item.position = Vector2.ZERO
	item.rotation = 0.0

	current_item.set_held_state(true)

func drop_item():
	if not current_item:
		return

	current_item.set_held_state(false)
	var item = current_item
	current_item = null
	if item.get_parent():
		item.get_parent().remove_child(item)
	get_tree().get_root().add_child(item)
	var distance = item_marker.global_position.distance_to(global_position)
	item.global_position = global_position + Vector2(cos(rotation), sin(rotation)) * distance
	item.rotation = rotation
	item.apply_impulse(Vector2(cos(rotation), sin(rotation)) * drop_impulse_strength)
	dropped_items.append(item)
