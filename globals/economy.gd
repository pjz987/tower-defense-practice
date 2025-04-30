extends Node

var gold: int = 0:
	set(value):
		gold = value
		Signals.gold_changed.emit()
