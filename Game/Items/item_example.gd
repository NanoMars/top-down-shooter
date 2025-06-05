extends Item

func press(obstacle_distance: float):
	$CPUParticles2D.emitting = true

func press_held(delta: float, obstacle_distance: float):
	pass

func release(obstacle_distance: float):
	pass
