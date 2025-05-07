class_name TowerUpgradeUI extends Control

@onready var tower_stats_label: Label = $TowerStatsLabel

var tower: Tower
var type_enum_to_string: Dictionary[int, String] = {
	0: "Archer",
	1: "Ice",
	2: "Poison",
}
var type_enum_to_description: Dictionary[int, String] = {
	0: "Sharp Arrows damage enemies",
	1: "Ice Storm slows enemies",
	2: "Poison Cloud damages over time"
}


func _ready() -> void:
	Signals.upgrade_selected_tower_changed.connect.call_deferred(update_selected_upgrade_tower_ui)
	tower_stats_label.text = ""

func update_selected_upgrade_tower_ui() -> void:
	tower = Economy.selected_upgrade_tower
	if tower == null: return
	tower_stats_label.text = """{type} Tower
	{description}
	Fire Rate: {fire_rate}s""".format({
		"type": type_enum_to_string[tower.type],
		"description": type_enum_to_description[tower.type],
		"fire_rate": tower.projectile_timer.wait_time
	})
