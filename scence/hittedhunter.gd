extends Node2D

var target_player: Node2D = null   # 要跟随的玩家

func _ready():
	# 从组中查找第一个玩家
	var players = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		# 如果没有玩家，特效也没必要存在，直接删除
		queue_free()
		return
	
	target_player = players[0]
	# 立即跳到玩家位置
	global_position = target_player.global_position
	
	# 5秒后自动消失
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _process(delta):
	# 每帧跟随玩家（如果玩家还活着）
	if target_player and is_instance_valid(target_player):
		global_position = target_player.global_position
	# 若玩家已删除，就停在原地
