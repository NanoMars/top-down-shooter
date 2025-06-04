# player.gd
extends CharacterBody2D
var controller_id: int = -1
var player_id: int = -1
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

@export var drop_impulse_strength: float = 200.0
@export var max_drop_time := 0.5
@export var hold_drop_multiplier := 8
@export var kill_velocity_threshold := 100.0

@export var death_particles_speed_variation: float = 2

var holding_use := false
var holding_drop := false

var holding_drop_time := 0.5

signal died(controller_id: int, player_id: int)


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
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.has_method("get_linear_velocity"):
			var other_velocity = collider.get_linear_velocity()
			var relative_velocity = (velocity - other_velocity).length()
			if relative_velocity > kill_velocity_threshold:
				await get_tree().process_frame
				kill(velocity - other_velocity)


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
		holding_drop = true
		holding_drop_time += delta
	else:
		if current_item and holding_drop:
			drop_item(holding_drop_time)
		holding_drop = false
		holding_drop_time = 0.0

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
	item.rotation = 0

	current_item.set_held_state(true)

func drop_item(speed: float = 0.0):
	if not current_item:
		return

	speed = (max(min(speed, max_drop_time), 0.0) * hold_drop_multiplier) + 1

	current_item.set_held_state(false)
	var item = current_item
	current_item = null
	if item.get_parent():
		item.get_parent().remove_child(item)
	get_tree().get_root().add_child(item)
	var distance = item_marker.global_position.distance_to(global_position)
	item.global_position = global_position + Vector2(cos(rotation), sin(rotation)) * distance
	item.rotation = rotation
	item.apply_impulse(Vector2(cos(rotation), sin(rotation)) * drop_impulse_strength * speed)
	dropped_items.append(item)

func kill(direction: Vector2 = Vector2.ZERO):
	var particles: CPUParticles2D = $CPUParticles2D
	remove_child(particles)
	get_tree().get_root().add_child(particles)
	particles.global_position = global_position
	particles.direction = -direction.normalized()
	particles.initial_velocity_min = direction.length()
	particles.initial_velocity_max = direction.length() * death_particles_speed_variation
	particles.emitting = true
	drop_item(0.0)
	emit_signal("died", controller_id, player_id)
	queue_free()
	
