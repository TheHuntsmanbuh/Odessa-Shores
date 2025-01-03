extends Node3D


@onready var player = $player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().call_group("structures", "update_player_position", player.global_transform.origin)
