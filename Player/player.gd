extends CharacterBody2D
const CONTROLLER_ID := 0
const DEADZONE := 0.1

var current_item: Node = null

var item_marker: Marker2D 

@export var movement_speed := 200.0
@export var acceleration := 1000.0
@export var friction := 500.0

@export var use_button: int = JOY_AXIS_TRIGGER_RIGHT
@export var drop_button: int = JOY_BUTTON_B

var holding_use := false

func _ready() -> void:
	item_marker = $Marker2D

func _physics_process(delta):
	# Movement and aiming
	var move_input: Vector2 = Vector2(
		Input.get_joy_axis(CONTROLLER_ID, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(CONTROLLER_ID, JOY_AXIS_LEFT_Y)
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
		Input.get_joy_axis(CONTROLLER_ID, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(CONTROLLER_ID, JOY_AXIS_RIGHT_Y)
	)
	if aim_input.length() > DEADZONE:
		rotation = aim_input.angle()

	# Item interaction

	if Input.is_joy_button_pressed(CONTROLLER_ID, use_button):
		if current_item and not holding_use :
			current_item.use()
		holding_use = true
	else:
		holding_use = false

	if Input.is_joy_button_pressed(CONTROLLER_ID, drop_button):
		drop_item()

func _on_body_entered(body: Node):
	if current_item == null and body is Item:
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
	get_parent().add_child(item)
	item.global_position = global_position + Vector2(cos(rotation), sin(rotation)) * 100
	item.rotation = rotation
	item.apply_impulse(Vector2(cos(rotation), sin(rotation)) * 300) 
