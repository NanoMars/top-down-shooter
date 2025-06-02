# bow.gd
extends Item

@export var animation_textures: Array[Texture] = []
@export var animation_curve: Curve
@export var animation_duration: float = 1.0

var button_held: bool = false
var progress: float = 0.0

@export var ammo: int = 3
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 300.0

func press():
	#$CPUParticles2D.emitting = true
	button_held = true

func release():
	button_held = false
	if progress >= 1.0 and ammo > 0:
		var projectile: Node2D = projectile_scene.instantiate()
		get_tree().get_root().add_child(projectile)
		projectile.global_position = global_position
		projectile.rotation = rotation
		projectile.linear_velocity = Vector2(cos(rotation), sin(rotation)) * projectile_speed
		ammo -= 1
		progress = 0.0

func _process(delta: float) -> void:
	if button_held:
		progress = min(progress + delta / animation_duration, 1.0)
	else:
		progress = max(progress - delta / animation_duration, 0.0)

	var animation_progress: float = max(min(animation_curve.sample(progress), 1.0), 0.0)
	$Sprite2D.texture = animation_textures[int(animation_progress * (animation_textures.size() - 1))]
