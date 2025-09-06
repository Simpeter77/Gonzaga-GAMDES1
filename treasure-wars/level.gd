extends Node2D

@export var max_enemies: int = 999
@export var min_interval: float = 1.0  # minimum seconds between spawns
@export var max_interval: float = 3.0  # maximum seconds between spawns

var spawned_count: int = 0

func _ready() -> void:
	$Timer.wait_time = randf_range(min_interval, max_interval)
	$Timer.start()

func _on_timer_timeout() -> void:
	if spawned_count < max_enemies:
		var minx = 50
		var maxx = 750
		var enemy = preload("res://Enemy.tscn").instantiate()
		add_child(enemy)
		enemy.global_position = Vector2(randf_range(minx, maxx), 0)
		spawned_count += 1

		# Set new random interval for next spawn
		$Timer.wait_time = randf_range(min_interval, max_interval)
		$Timer.start()
	else:
		$Timer.stop()
