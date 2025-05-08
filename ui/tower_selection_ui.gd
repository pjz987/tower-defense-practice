class_name TowerSelectionUI extends GridContainer

@onready var archer_tower_button: Button = $ArcherTowerButton
@onready var cannon_tower_button: Button = $CannonTowerButton
@onready var crossbow_tower_button: Button = $CrossbowTowerButton
@onready var ice_tower_button: Button = $IceTowerButton
@onready var lightning_tower_button: Button = $LightningTowerButton
@onready var poison_tower_button: Button = $PoisonTowerButton
@onready var buttonsound = MasterAudio.buttonpress1_player



func _ready() -> void:
	archer_tower_button.pressed.connect(func(): Economy.selected_tower = Economy.Tower.ARCHER)
	cannon_tower_button.pressed.connect(func(): Economy.selected_tower = Economy.Tower.CANNON)
	crossbow_tower_button.pressed.connect(func(): Economy.selected_tower = Economy.Tower.CROSSBOW)
	ice_tower_button.pressed.connect(func(): Economy.selected_tower = Economy.Tower.ICE)
	lightning_tower_button.pressed.connect(func(): Economy.selected_tower = Economy.Tower.LIGHTNING)
	poison_tower_button.pressed.connect(func(): Economy.selected_tower = Economy.Tower.POISON)


func _on_archer_tower_button_pressed() -> void:
	buttonsound.play()
	pass # Replace with function body.


func _on_ice_tower_button_pressed() -> void:
	buttonsound.play()
	pass # Replace with function body.


func _on_poison_tower_button_pressed() -> void:
	buttonsound.play()
	pass # Replace with function body.
