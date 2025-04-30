extends Area2D
class_name Enemy

var ENEMY_DEATH_PARTICLES_SCENE: PackedScene = preload("res://enemy_death_particles.tscn")

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
	var death_particles = ENEMY_DEATH_PARTICLES_SCENE.instantiate()
	death_particles.global_position = global_position
	get_tree().current_scene.add_child(death_particles)
	death_particles.emitting = true
