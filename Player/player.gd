extends CharacterBody2D
const JOYSTICK_INDEX := 0
const DEADZONE := 0.1

@export var movement_speed := 200.0
@export var acceleration := 1000.0
@export var friction := 500.0

func _physics_process(delta):
	var move_input: Vector2 = Vector2(
		Input.get_joy_axis(JOYSTICK_INDEX, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(JOYSTICK_INDEX, JOY_AXIS_LEFT_Y)
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
		Input.get_joy_axis(JOYSTICK_INDEX, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(JOYSTICK_INDEX, JOY_AXIS_RIGHT_Y)
	)
	if aim_input.length() > DEADZONE:
		rotation = aim_input.angle()