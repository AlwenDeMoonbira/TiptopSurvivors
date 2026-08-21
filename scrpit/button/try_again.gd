extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset() -> void:
	# 重新运行 MainScence 场景（场景切换后，God_and_world._ready 会重新生成玩家和敌人）
	var scene_path := "res://scence/MainScence.tscn"
	var err = get_tree().change_scene_to_file(scene_path)
	if err != OK:
		push_error("Failed to change scene to %s (err=%d)" % [scene_path, err])
