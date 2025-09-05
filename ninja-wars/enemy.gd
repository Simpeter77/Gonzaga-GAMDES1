extends CharacterBody2D

const SPEED = 500.0
@export var start_delay: float = 0.0   # delay before moving

@onready var character_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Movement control
var direction: int = -1
var can_move: bool = false

func _ready() -> void:
	# Optional wait before starting movement
	if start_delay > 0:
		await get_tree().create_timer(start_delay).timeout
	can_move = true

func _physics_process(delta: float) -> void:
	if not can_move:
		return

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Move enemy left to right vv
	velocity.x = direction * SPEED
	character_sprite.flip_h = direction < 0

	move_and_slide()

	#  Check collisions after moving
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("player"):
			_game_over()

	# Reverse direction when hitting a wall
	if is_on_wall():
		direction *= -1

func _game_over() -> void:
	print("Game Over: Enemy touched the player")
	get_tree().reload_current_scene()
