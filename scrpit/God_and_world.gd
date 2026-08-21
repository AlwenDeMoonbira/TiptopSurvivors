extends Node2D
@export var expnow:int = 0
@export var level_of_player:int = 1
@export var exp_list: Array = [
	0, 100, 300, 600, 1000, 2000, 3000, 4000, 5000, 6000,          # 1~10 级
	7200, 8400, 9600, 10800, 12000, 13500, 15000, 16500, 18000, 19500, # 11~20 级
	21300, 23100, 24900, 26700, 28500, 30700, 32900, 35100, 37300, 39500, # 21~30 级
	42200, 44900, 47600, 50300, 53000, 56300, 59600, 62900, 66200 ,70000      # 31~39 级（不含 40→41）
] # 每级所需经验值列表

@export var max_level:int = 40
@export var expSTRENGTH:int = 0
# 每级升级奖励
@export var strength_per_level: int = 1   # 每级增加的攻击力
@export var health_per_level: int = 200    # 每级增加的生命值
@export var hunter: PackedScene = preload("res://scence/hunter.tscn")
@export var slime: PackedScene = preload("res://scence/slime.tscn")

# --- 敌人无限生成配置 ---
@export var max_enemies: int = 50          # 场上敌人数量上限
@export var spawn_interval: float = 0.5    # 生成间隔（秒）
@export var spawn_rect_min: Vector2 = Vector2(-440, 0)   # 出生范围左上角（x, y）
@export var spawn_rect_max: Vector2 = Vector2(440, 600)  # 出生范围右下角（x, y）

var _spawn_timer: float = 0.0
var _spawn_enabled: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 玩家只召唤一次
	player_summon()
	# 启动源源不断的敌人生成
	enemy_summon()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 场上敌人数量不足上限时，按间隔持续补充，实现源源不断生成
	if not _spawn_enabled:
		return
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() < max_enemies:
		_spawn_timer -= delta
		if _spawn_timer <= 0.0:
			_spawn_timer = spawn_interval
			_spawn_slime()



func add_exp(amount: int) -> void:
	expnow += amount + expSTRENGTH
	print("usergetxp")
	while level_of_player < exp_list.size() and expnow >= exp_list[level_of_player]:
		expnow -= exp_list[level_of_player]
		level_of_player += 1
		# 升级奖励：同步玩家等级并强化属性
		_apply_level_up_rewards()
	# 达到 25 级：胜利，切换到 win 场景
	if level_of_player >= 20:
		get_tree().change_scene_to_file("res://scence/win.tscn")
		return
	get_node("/root/ms/ui").exp = expnow
	get_node("/root/ms/ui").level = level_of_player
	get_node("/root/ms/ui").level_maxvalue = exp_list[level_of_player] if level_of_player < exp_list.size() else 0
func set_health(new_health: int) -> void:
	# 这里可以添加血量变化的逻辑，比如更新 UI 等
	get_node("/root/ms/ui").health = new_health

func set_exp(new_exp: int) -> void:
	get_node("/root/ms/ui").exp = new_exp

func _apply_level_up_rewards() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	player.level = level_of_player             # 玩家对象自身等级同步
	player.strength += strength_per_level      # 每次升级增加攻击力
	player.health += health_per_level          # 每次升级增加生命值
	set_health(player.health)                  # 同步 UI 显示的新血量


func enemy_summon(monsternumber=0) -> void:
	# 开启持续生成；monsternumber 指定立即额外生成的数量
	_spawn_enabled = true
	_spawn_timer = 0.0
	for i in range(monsternumber):
		_spawn_slime()

func player_summon(playernumber=0) -> void:
	# 玩家只召唤一次：场上已有玩家则不再创建
	if get_tree().get_first_node_in_group("player") != null:
		return
	if hunter == null:
		return
	var hunter_instance = hunter.instantiate()
	add_child(hunter_instance)
	hunter_instance.global_position = Vector2(0, 90)

func _spawn_slime() -> void:
	if slime == null:
		return
	var slime_instance = slime.instantiate()
	add_child(slime_instance)
	# 在指定矩形范围内随机生成
	var spawn_x = randf_range(spawn_rect_min.x, spawn_rect_max.x)
	var spawn_y = randf_range(spawn_rect_min.y, spawn_rect_max.y)
	slime_instance.global_position = Vector2(spawn_x, spawn_y)
