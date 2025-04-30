extends Area2D
class_name Enemy

@export var gold_reward: int = 1

@export var health: int = 2:
	set(value):
		health = value
		if health <= 0:
			die()

func take_hit(projectile: Projectile) -> void:
	health -= projectile.damage

func die() -> void:
	queue_free()
	Economy.gold += gold_reward
