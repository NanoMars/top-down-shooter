extends Item

@export var break_threshold: float = 100.0

func _integrate_forces(state):
	var velocity = linear_velocity
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)

		var other_velocity = collider.get_linear_velocity() if collider and collider.has_method("get_linear_velocity") else Vector2.ZERO

		var relative_velocity = (velocity - other_velocity).length()
		print("contacted with: ", collider.name, " relative velocity: ", relative_velocity)
		if relative_velocity > break_threshold: 
			print("Crate collided with: ", collider.name)
			break_and_drop()



func break_and_drop(direction: Vector2 = Vector2.ZERO):
	pass
