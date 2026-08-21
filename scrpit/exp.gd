extends Area2D
@export var value:int=100
@export var world:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func was_get(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_node("/root/ms").add_exp(value)
		#print("114514玩家获得了 %d 点经验值！" % value)
		
		queue_free()
