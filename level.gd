extends Node2D

@onready var enemy_spawner_timer: Timer = $EnemySpawnerTimer
@onready var path_2d: Path2D = $Path2D
@onready var grid_placement_tile_map_layer: TileMapLayer = $GridPlacementTileMapLayer
@onready var path_tile_map_layer: TileMapLayer = $PathTileMapLayer
@onready var tower_placement_indicator_sprite: Sprite2D = $TowerPlacementIndicatorSprite
@onready var towers: Node2D = $Towers
@onready var wave_label: Label = $UI/WaveLabel

@export var wave_count: int = 0
@export var enemy_count: int = 0
@export var tower_placement_offset: Vector2i = Vector2i()
var tower_cost: int = 5
var cell_size: Vector2i = Vector2i(16, 16)
var wave_done_spawning: bool = false


var ENEMY_FOLLOW_SCENE: PackedScene = preload("res://enemies/enemy_follow_2d.tscn")
var BAT_ENEMY_FOLLOW_SCENE: PackedScene = preload("res://enemies/bat_enemy_follow_2d.tscn")
var DEMON_ENEMY_FOLLOW_SCENE: PackedScene = preload("res://enemies/demon_enemy_follow_2d.tscn")
var GHOST_ENEMY_FOLLOW_SCENE: PackedScene = preload("res://enemies/ghost_enemy_follow_2d.tscn")
var SLIME_ENEMY_FOLLOW_SCENE: PackedScene = preload("res://enemies/slime_enemy_follow_2d.tscn")
var TOWER_SCENE: PackedScene = preload("res://tower.tscn")

var enemy_scenes_dict: Dictionary[String, PackedScene] = {
	"bat": BAT_ENEMY_FOLLOW_SCENE,
	"slime": SLIME_ENEMY_FOLLOW_SCENE,
	"demon": DEMON_ENEMY_FOLLOW_SCENE,
	"ghost": GHOST_ENEMY_FOLLOW_SCENE,
}

@export var waves: Array[Array] = [
	["bat", "bat", "bat", "bat", "bat", "bat"],
	["slime", "slime", "slime"],
	["demon", "demon", "demon"],
	["ghost", "ghost", "ghost"],
]

var enemy_follow_scenes: Array[PackedScene] = [
	BAT_ENEMY_FOLLOW_SCENE,
	DEMON_ENEMY_FOLLOW_SCENE,
	GHOST_ENEMY_FOLLOW_SCENE,
	SLIME_ENEMY_FOLLOW_SCENE,
]



func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.CORNFLOWER_BLUE)
	wave_spawner()
	EnemyManager.enemy_died.connect(check_is_wave_over)
	GameManager.castle_destroyed.connect(func(): wave_label.text = "Game Over")
	Signals.selected_tower_changed.connect(set_tower_placement_indicator_sprite_texture)

func _process(delta: float) -> void:
	grid_cell_selection()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed == true:
			if Economy.gold >= tower_cost:
				var selected_cell_coords: Vector2i = grid_placement_tile_map_layer.local_to_map(get_global_mouse_position())
				var data: TileData = grid_placement_tile_map_layer.get_cell_tile_data(selected_cell_coords)
				if data != null:
					grid_placement_tile_map_layer.set_cell(selected_cell_coords, -1) # makes the TileData null
					var tower = TOWER_SCENE.instantiate()
					tower.global_position = selected_cell_coords * cell_size + tower_placement_offset
					towers.add_child(tower)
					Economy.gold -= tower_cost


func grid_cell_selection() -> void:
	var selected_cell_coords: Vector2i = grid_placement_tile_map_layer.local_to_map(get_global_mouse_position())
	tower_placement_indicator_sprite.global_position = selected_cell_coords * cell_size


func wave_spawner() -> void:
	wave_done_spawning = false
	wave_label.text = "Wave " + str(wave_count + 1)
	if wave_count >= len(waves):
		wave_label.text = "Congralutations!"
		return
	var wave = waves[wave_count]
	for enemy_scene_key in wave:
		await get_tree().create_timer(2.0).timeout
		var enemy_scene =  enemy_scenes_dict[enemy_scene_key].instantiate()
		path_2d.add_child(enemy_scene)
	wave_done_spawning = true

func check_is_wave_over() -> void:
	var wave_is_over = wave_done_spawning and await EnemyManager.are_enemies_empty()
	if wave_is_over:
		wave_count += 1
		if wave_count < len(waves):
			wave_label.text = "Wave " + str(wave_count + 1) + " Incoming"
			await get_tree().create_timer(3.0).timeout
		wave_spawner()
	

func set_tower_placement_indicator_sprite_texture() -> void:
	match Economy.selected_tower:
		Economy.Tower.NONE:
			tower_placement_indicator_sprite.texture = null
		Economy.Tower.ARCHER:
			tower_placement_indicator_sprite.texture = load("res://Simple Tower Defense/Towers/Combat Towers/spr_tower_archer.png")
		Economy.Tower.CANNON:
			tower_placement_indicator_sprite.texture = load("res://Simple Tower Defense/Towers/Combat Towers/spr_tower_cannon.png")
		Economy.Tower.CROSSBOW:
			tower_placement_indicator_sprite.texture = load("res://Simple Tower Defense/Towers/Combat Towers/spr_tower_crossbow.png")
		Economy.Tower.ICE:
			tower_placement_indicator_sprite.texture = load("res://Simple Tower Defense/Towers/Combat Towers/spr_tower_ice_wizard.png")
		Economy.Tower.LIGHTNING:
			tower_placement_indicator_sprite.texture = load("res://Simple Tower Defense/Towers/Combat Towers/spr_tower_lightning_tower.png")
		Economy.Tower.POISON:
			tower_placement_indicator_sprite.texture = load("res://Simple Tower Defense/Towers/Combat Towers/spr_tower_poison_wizard.png")
		
