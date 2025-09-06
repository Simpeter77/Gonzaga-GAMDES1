extends Area2D

@export var speed: float = 1000.0
var direction: int = 1

func _process(delta: float) -> void:
	position.x += direction * speed * delta

	if position.x < -1000 or position.x > 2000:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy"):
		print("Enemy hit!")
		body.queue_free() 
		queue_free()      
