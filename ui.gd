class_name UI extends Control
@onready var gold_label: RichTextLabel = $GoldLabel

func _ready() -> void:
	gold_label.text = "Gold: " + str(Economy.gold)
	Signals.gold_changed.connect(func(): gold_label.text = "Gold: " + str(Economy.gold))
