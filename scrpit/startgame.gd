extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("startgame: _ready called")
	# Godot 4: use Callable to connect signals in code
	pressed.connect(Callable(self, "_on_pressed"))


func _on_pressed() -> void:
	print("startgame: _on_pressed called")
	var scene_path := "res://scence/MainScence.tscn"
	var err = get_tree().change_scene_to_file(scene_path)
	if err != OK:
		push_error("Failed to change scene to %s (err=%d)" % [scene_path, err])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
