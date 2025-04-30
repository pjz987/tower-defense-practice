extends Node2D

@onready var enemy_spawner_timer: Timer = $EnemySpawnerTimer
@onready var path_2d: Path2D = $Path2D
@onready var grid_placement_tile_map_layer: TileMapLayer = $GridPlacementTileMapLayer
@onready var path_tile_map_layer: TileMapLayer = $PathTileMapLayer
@onready var tower_placement_indicator_sprite: Sprite2D = $TowerPlacementIndicatorSprite
@onready var towers: Node2D = $Towers

var tower_cost: int = 5
var cell_size: Vector2i = Vector2i(16, 16)
@export var tower_placement_offset: Vector2i = Vector2i()

var ENEMY_FOLLOW_SCENE: PackedScene = preload("res://enemy_follow_2d.tscn")
var TOWER_SCENE: PackedScene = preload("res://tower.tscn")

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.CORNFLOWER_BLUE)

func _process(delta: float) -> void:
	grid_cell_selection()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed == true:
			if Economy.gold >= tower_cost:
				var tower = TOWER_SCENE.instantiate()
				var selected_cell_coords: Vector2i = grid_placement_tile_map_layer.local_to_map(get_global_mouse_position())
				tower.global_position = selected_cell_coords * cell_size + tower_placement_offset
				towers.add_child(tower)
				Economy.gold -= tower_cost

func _on_enemy_spawner_timer_timeout() -> void:
	var enemy_follow = ENEMY_FOLLOW_SCENE.instantiate()
	path_2d.add_child(enemy_follow)

func grid_cell_selection() -> void:
	var selected_cell_coords: Vector2i = grid_placement_tile_map_layer.local_to_map(get_global_mouse_position())
	tower_placement_indicator_sprite.global_position = selected_cell_coords * cell_size
