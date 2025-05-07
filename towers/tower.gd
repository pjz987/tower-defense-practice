extends Node2D
class_name Tower

@onready var projectile_spawn_point: Node2D = $ProjectileSpawnPoint
@onready var projectile_timer: Timer = $ProjectileTimer
@onready var shotsound = MasterAudio.arrowshoot1_player
@onready var upgrade_click_area_2d: Area2D = $UpgradeClickArea2D
@onready var tower_sprite: Sprite2D = $TowerSprite
@onready var range_sprite: Sprite2D = $TowerSprite/RangeSprite

var PROJECTILE_SCENE: PackedScene = preload("res://towers/projectile.tscn")
var ICE_PROJECTILE_SCENE: PackedScene = preload("res://towers/ice_projectile.tscn")
var POISON_PROJECTILE_SCENE: PackedScene = preload("res://towers/poison_projectile.tscn")
var TOWER_UPGRADE_UI_SCENE: PackedScene = preload("res://ui/tower_upgrade_ui.tscn")

var enemies: Array[Enemy] = []
var ready_to_shoot: bool = true
var mouse_over_upgrade_area: bool = false

enum Level {ONE, TWO, THREE}
@export var level: Level
enum Type {ARCHER, ICE, POISON}
@export var type: Type
@export var cost: int = 5
@export var tower_placement_offset: Vector2i

func _ready() -> void:
	upgrade_click_area_2d.mouse_entered.connect(func(): mouse_over_upgrade_area = true)
	upgrade_click_area_2d.mouse_exited.connect(func(): mouse_over_upgrade_area = false)

func _process(delta: float) -> void:
	enemies.sort_custom(func(enemy_a: Enemy, enemy_b: Enemy):
		var enemy_a_follow: EnemyFollow2D = enemy_a.get_parent()
		var enemy_b_follow: EnemyFollow2D = enemy_b.get_parent()
		return enemy_a_follow.progress > enemy_b_follow.progress
	)
	range_sprite.visible = Economy.selected_upgrade_tower == self

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	if not (event.button_index == 1 and event.pressed == true):
		return
	if mouse_over_upgrade_area:
		tower_sprite.material.set_shader_parameter("width", 1.0)
		Economy.selected_upgrade_tower = self
	else:
		tower_sprite.material.set_shader_parameter("width", 0.0)

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
	
