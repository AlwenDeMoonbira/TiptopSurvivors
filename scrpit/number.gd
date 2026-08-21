extends Node2D
var something=1
@export var text=1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	something=Vector2(randf_range(-100, 100),randf_range(-100, 100))

	get_node("Label").text=text
	await get_tree().create_timer(1).timeout
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position+=something*delta
	something*=0.8
