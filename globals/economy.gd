extends Node

var gold: int = 10:
	set(value):
		gold = value
		Signals.gold_changed.emit()
