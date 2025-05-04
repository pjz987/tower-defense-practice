class_name Castle extends Area2D

@onready var health_label: Label = $HealthLabel
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var damage_effect_timer: Timer = $DamageEffectTimer

var CASTLE_DESTRUCTION_PARTICLES_SCENE: PackedScene = preload("res://castle_destruction_particles.tscn")

@export var health: int = 20:
	set(value):
		health = value
		update_health_label()
		if health <= 0:
			die()


func _ready() -> void:
	update_health_label()
	damage_effect_timer.timeout.connect(_on_damage_effect_timer_timeout)

func update_health_label() -> void:
	health_label.text = "Health: " + str(health)

func take_hit(enemy: Enemy) -> void:
	health -= enemy.attack_power
	sprite_2d.material.set_shader_parameter("flash_modifier", 0.5)
	damage_effect_timer.start(0.5)


func die() -> void:
	var castle_particles = CASTLE_DESTRUCTION_PARTICLES_SCENE.instantiate()
	castle_particles.global_position = global_position
	get_tree().current_scene.add_child(castle_particles)
	castle_particles.emitting = true
	queue_free()
	health_label.text = "AND YOU\nDEAD"
	GameManager.castle_destroyed.emit()

func _on_damage_effect_timer_timeout() -> void:
	sprite_2d.material.set_shader_parameter("flash_modifier", 0.0)
