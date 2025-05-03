extends Node

signal enemy_died



func are_enemies_empty() -> bool:
	return get_tree().get_nodes_in_group("enemies").is_empty()
