extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -800.0

@onready var character_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if (velocity.x > 1 or velocity.x < -1):
		character_sprite.animation = "run"
	else:
		character_sprite.animation = "default"

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		character_sprite.animation = "jump"

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		character_sprite.animation = "jump"

	# Duck (mid-air boost upward in your code)
	if Input.is_action_just_pressed("duck") and not is_on_floor():
		velocity.y = -1 * JUMP_VELOCITY
		character_sprite.animation = "duck"

	# Movement
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 45)

	character_sprite.flip_h = velocity.x < 0

	move_and_slide()
	
	#  Check collisions after moving
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("enemya"):
			_game_over()
	
func _game_over() -> void:
	print("Game Over: Player touched the enemy")
	get_tree().reload_current_scene()
