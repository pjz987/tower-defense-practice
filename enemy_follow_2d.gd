extends PathFollow2D
class_name EnemyFollow2D

var speed: float = 25.0

func _physics_process(delta: float) -> void:
	progress += speed * delta
