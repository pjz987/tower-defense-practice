extends Area2D
class_name Enemy

var ENEMY_DEATH_PARTICLES_SCENE: PackedScene = preload("res://enemy_death_particles.tscn")

@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

@export var gold_reward: int = 1
@export var attack_power: int = 1

var castle: Castle = null

@export var health: int = 2:
	set(value):
		health = value
		if health <= 0:
			die()

var at_castle: bool = false

func take_hit(projectile: Projectile) -> void:
	health -= projectile.damage

func die() -> void:
	queue_free()
	Economy.gold += gold_reward
	var death_particles = ENEMY_DEATH_PARTICLES_SCENE.instantiate()
	death_particles.global_position = global_position
	get_tree().current_scene.add_child(death_particles)
	death_particles.emitting = true



func _on_area_entered(area: Area2D) -> void:
	if area is Castle:
		castle = area
		at_castle = true
		area.take_hit(self)
		attack_cooldown_timer.start()


func _on_area_exited(area: Area2D) -> void:
	pass # Replace with function body.


func _on_attack_cooldown_timer_timeout() -> void:
	if at_castle and is_instance_valid(castle):
		castle.take_hit(self)
		attack_cooldown_timer.start()
