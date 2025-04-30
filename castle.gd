class_name Castle extends Area2D

@onready var health_label: Label = $HealthLabel

var CASTLE_DESTRUCTION_PARTICLES_SCENE: PackedScene = preload("res://castle_destruction_particles.tscn")

@export var health: int = 20:
	set(value):
		health = value
		update_health_label()
		if health <= 0:
			die()


func _ready() -> void:
	update_health_label()

func update_health_label() -> void:
	health_label.text = "Health: " + str(health)

func take_hit(enemy: Enemy) -> void:
	health -= enemy.attack_power

func die() -> void:
	var castle_particles = CASTLE_DESTRUCTION_PARTICLES_SCENE.instantiate()
	castle_particles.global_position = global_position
	get_tree().current_scene.add_child(castle_particles)
	castle_particles.emitting = true
	queue_free()
	health_label.text = "AND YOU\nDEAD"
