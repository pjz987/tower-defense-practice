extends Node

var gold: int = 20:
	set(value):
		gold = value
		Signals.gold_changed.emit()

enum Tower { # selectable towers from the shop ui
	NONE,
	ARCHER,
	CANNON,
	CROSSBOW,
	ICE,
	LIGHTNING,
	POISON,
}

var selected_tower = Tower.NONE:
	set(value):
		selected_tower = value
		Signals.selected_tower_changed.emit()

var selected_upgrade_tower: Tower:
	set(value):
		selected_upgrade_tower = value
		Signals.upgrade_selected_tower_changed.emit()
