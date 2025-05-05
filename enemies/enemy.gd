extends Area2D
class_name Enemy

var ENEMY_DEATH_PARTICLES_SCENE: PackedScene = preload("res://enemies/enemy_death_particles.tscn")

@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var damage_effect_timer: Timer = $DamageEffectTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var iced_timer: Timer = $IcedTimer
@onready var poisoned_timer: Timer = $PoisonedTimer
@onready var poison_damage_timer: Timer = $PoisonDamageTimer
@onready var poison_particles: GPUParticles2D = $PoisonParticles

@export var gold_reward: int = 1
@export var attack_power: int = 1
@export var attack_flash_color: Color = Color("#c42430")
@export var iced_flash_color: Color = Color("#0069aa")
@export var poisoned_flash_color: Color = Color("#33984b")


var is_iced: bool = false
var is_poisoned: bool = false
var is_damage_effect: bool = false
var at_castle: bool = false

var enemy_follow: EnemyFollow2D
var castle: Castle = null


@export var health: int = 2:
	set(value):
		health = value
		if health <= 0:
			die()


func _ready() -> void:
	damage_effect_timer.timeout.connect(func(): 
		sprite_2d.material.set_shader_parameter("flash_modifier", 0.0)
		is_damage_effect = false
	)
	iced_timer.timeout.connect(get_de_iced)
	poisoned_timer.timeout.connect(get_de_poisoned)
	poison_damage_timer.timeout.connect(func(): health -=1)
	enemy_follow = get_parent()

func _process(delta: float) -> void:
	manage_shader_params()

func take_hit(projectile: Projectile) -> void:
	match projectile.type:
		Projectile.Type.ARROW:
			health -= projectile.damage
			sprite_2d.material.set_shader_parameter("flash_modifier", 0.5)
			damage_effect_timer.start()
			is_damage_effect = true
		Projectile.Type.ICE:
			get_iced()
		Projectile.Type.POISON:
			get_poisoned()
	

func die() -> void:
	queue_free()
	Economy.gold += gold_reward
	var death_particles = ENEMY_DEATH_PARTICLES_SCENE.instantiate()
	death_particles.global_position = global_position
	get_tree().current_scene.add_child(death_particles)
	death_particles.emitting = true
	EnemyManager.enemy_died.emit.call_deferred()

func get_iced() -> void:
	if !is_iced:
		enemy_follow.speed /= 2.0
	sprite_2d.material.set_shader_parameter("flash_color", iced_flash_color)
	sprite_2d.material.set_shader_parameter("flash_modifier", 0.5)
	iced_timer.start()
	is_iced = true

func get_de_iced() -> void:
	is_iced = false
	enemy_follow.speed *= 2.0
	sprite_2d.material.set_shader_parameter("flash_color", attack_flash_color)
	sprite_2d.material.set_shader_parameter("flash_modifier", 0.0)
	
func get_poisoned() -> void:
	is_poisoned = true
	poison_damage_timer.start()
	poison_particles.emitting = true
	#sprite_2d.material.set_shader_parameter("flash_color", poisoned_flash_color)
	#sprite_2d.material.set_shader_parameter("flash_modifier", 0.5)
	poisoned_timer.start()
	#poison_damage_timer.start()
	
func get_de_poisoned() -> void:
	is_poisoned = false
	poison_damage_timer.stop()
	poison_particles.emitting = false
	#sprite_2d.material.set_shader_parameter("flash_color", attack_flash_color)
	#sprite_2d.material.set_shader_parameter("flash_modifier", 0.0)
	
func manage_shader_params() -> void:
	if is_iced:
		sprite_2d.material.set_shader_parameter("flash_color", iced_flash_color)
		sprite_2d.material.set_shader_parameter("flash_modifier", 0.5)
	if is_damage_effect:
		sprite_2d.material.set_shader_parameter("flash_color", attack_flash_color)
		sprite_2d.material.set_shader_parameter("flash_modifier", 0.5)
	

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
