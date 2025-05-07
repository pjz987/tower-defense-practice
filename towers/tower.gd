extends Node2D
class_name Tower

@onready var projectile_spawn_point: Node2D = $ProjectileSpawnPoint
@onready var projectile_timer: Timer = $ProjectileTimer
@onready var shotsound = MasterAudio.arrowshoot1_player

var PROJECTILE_SCENE: PackedScene = preload("res://towers/projectile.tscn")
var ICE_PROJECTILE_SCENE: PackedScene = preload("res://towers/ice_projectile.tscn")
var POISON_PROJECTILE_SCENE: PackedScene = preload("res://towers/poison_projectile.tscn")

var enemies: Array[Enemy] = []

var ready_to_shoot: bool = true

enum Type {ARCHER, ICE, POISON}
@export var type: Type
@export var cost: int = 5

@export var tower_placement_offset: Vector2i

func spawn_projectile(enemy: Enemy) -> void:
	var projectile: Projectile
	match type:
		Type.ARCHER:
			projectile = PROJECTILE_SCENE.instantiate()
		Type.ICE:
			projectile = ICE_PROJECTILE_SCENE.instantiate()
			shotsound = MasterAudio.iceshoot1_player
		Type.POISON:
			projectile = POISON_PROJECTILE_SCENE.instantiate()
			shotsound = MasterAudio.poisonshoot1_player
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
			shotsound.play()

			#MasterAudio.arrowshoot1_player.play()
			projectile_timer.start()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Enemy:
		enemies.erase(area)

func _on_projectile_timer_timeout() -> void:
	ready_to_shoot = true
	if enemies:
		spawn_projectile(enemies[0])
		shotsound.play()
		#MasterAudio.arrowshoot1_player.play()
		projectile_timer.start()
	
