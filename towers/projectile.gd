extends Area2D
class_name Projectile

var target_position: Vector2
var speed: float = 100.0
@export var damage: int = 1
var direction: Vector2

enum Type {ARROW, ICE, POISON}
@export var type: Type

func _ready() -> void:
	direction = (target_position - position).normalized()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta



func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		area.take_hit(self)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
