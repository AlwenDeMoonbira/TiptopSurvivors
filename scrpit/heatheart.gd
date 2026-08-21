extends Node2D
@export var level:int=0
@export var max_number:int=5
@export var player = null
@export var bullet_scene:PackedScene
@export var enable:bool=true
@export var stength:int=0
var stuffname = "heatheart"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 从组中查找第一个玩家
	var players = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		# 如果没有玩家，特效也没必要存在，直接删除
		queue_free()
		return
		
	
	player = players[0]
	# 立即跳到玩家位置
	global_position = player.global_position
	stength=player.strength
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player and is_instance_valid(player):
		global_position = player.global_position
		stength = player.strength  # 持续同步玩家力量，升级后新生成的子弹立即生效
	else:
		queue_free()
	
	check_fire()

func check_fire() -> void:
	var bullets = get_tree().get_nodes_in_group("heartfire")
	
	if bullets.size() < max_number:
		
		print("当前子弹数量: ", bullets.size(), "，小于最大数量: ", max_number, "，可以发射新子弹。")
		
		var fire_bullet = bullet_scene.instantiate()
		fire_bullet.global_position = global_position
		
		fire_bullet.angle = randf_range(-2*PI, 2*PI) 
		fire_bullet.strength=stength
		get_tree().current_scene.add_child(fire_bullet)
	
		
