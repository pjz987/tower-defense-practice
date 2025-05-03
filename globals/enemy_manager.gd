extends Node

signal enemy_died



func are_enemies_empty() -> bool:
	await get_tree().create_timer(0.01).timeout
	return get_tree().get_nodes_in_group("enemies").is_empty()
