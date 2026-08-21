extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 等待 5 秒后进入 lose 场景
	await get_tree().create_timer(5.0).timeout
	var scene_path := "res://scence/lose.tscn"
	var err = get_tree().change_scene_to_file(scene_path)
	if err != OK:
		push_error("Failed to change scene to %s (err=%d)" % [scene_path, err])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
