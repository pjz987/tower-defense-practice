extends Node2D
class_name Tower

@onready var projectile_spawn_point: Node2D = $ProjectileSpawnPoint
@onready var projectile_timer: Timer = $ProjectileTimer

var PROJECTILE_SCENE: PackedScene = preload("res://towers/projectile.tscn")

var enemies: Array[Enemy] = []

var ready_to_shoot: bool = true

func spawn_projectile(enemy: Enemy) -> void:
	var projectile: Projectile = PROJECTILE_SCENE.instantiate()
	projectile.global_position = projectile_spawn_point.global_position
	projectile.look_at(enemy.global_position)
	projectile.target_position = enemy.global_position
	get_tree().current_scene.add_child.call_deferred(projectile)
	ready_to_shoot = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		enemies.append(area)
		if ready_to_shoot:
			spawn_projectile(area)
			projectile_timer.start()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Enemy:
		enemies.erase(area)

func _on_projectile_timer_timeout() -> void:
	ready_to_shoot = true
	if enemies:
		spawn_projectile(enemies[0])
		projectile_timer.start()
	
