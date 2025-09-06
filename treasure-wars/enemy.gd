extends CharacterBody2D

const SPEED = 400.0
@export var start_delay: float = 0.0
@onready var character_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction: int = [-1, 1].pick_random()
var can_move: bool = false

func _ready() -> void:
	if start_delay > 0:
		await get_tree().create_timer(start_delay).timeout
	can_move = true

func _physics_process(delta: float) -> void:
	if not can_move:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = direction * SPEED
	character_sprite.flip_h = direction < 0
	move_and_slide()

	if is_on_wall():
		direction *= -1

	# Player collision
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is CharacterBody2D and collider.is_in_group("Player"):
			_game_over()


func _game_over() -> void:
	print("Game Over: Enemy touched the player")
	get_tree().reload_current_scene()
