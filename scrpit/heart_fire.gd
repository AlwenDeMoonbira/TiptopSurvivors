extends Node2D
@export var master_item: Node2D = null
@export var size: float = 1
@export var speed: float = 5.0
@export var angle: float = 0.0
@export var radious: float = 50.0
@export var basic_damage: int = 5
@export var strength: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var list_of_stuff = get_tree().get_nodes_in_group("stuff")
	for i in list_of_stuff:
		if i.stuffname == "heatheart":
			master_item = i
			break
	await get_tree().create_timer(5).timeout
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_wheather_live()
	# 持续同步主人的力量值，玩家升级后子弹伤害随之提升
	if master_item != null and is_instance_valid(master_item):
		strength = int(master_item.get("stength"))


func hitted(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var enemy = area 
		enemy.take_damage(strength+basic_damage)


func check_wheather_live() -> void:
	if master_item == null or not is_instance_valid(master_item):
		queue_free()

func _physics_process(delta: float) -> void:
	geomove(delta)

func geomove(delta: float) -> void:
	var tempos = master_item.global_position
	angle += speed * delta
	position = tempos + Vector2(cos(angle), sin(angle)) * radious
