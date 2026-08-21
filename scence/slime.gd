extends Area2D

@export var health: int = 20
@export var attack_value: int = 10
@export var defense: int = 0
@export var speed: float = 80.0
@export var chase_range: float = 300.0
@export var stop_distance: float = 20.0

# 新增攻击相关参数
@export var attack_cooldown: float = 1.0        # 攻击冷却（秒）
@export var attack_range: float = 30.0          # 攻击触发距离
@export var knockback_force: float = 100      # 击飞力度（像素/秒）
@export var knockback_time: float = 0.3       # 击飞持续时长（秒）
@export var death_effect: PackedScene  # 用于死亡时的特效节点，确保在场景树中存在
@export var exp_number: int = 10  # 击杀后掉落的经验值数量
@export var exp_drop_scene: PackedScene  # 用于掉落经验值的场景，确保在场景树中存在
@export var hitted: bool = false  # 用于标记是否被击中，防止在击退期间继续移动
@export var number: PackedScene  # 用于显示伤害数字的场景，确保在场景树中存在

@export var monster_number=0
var player: Node2D = null
var attack_timer: float = 0.0
var knockback_timer: float = 0.0             # 击飞剩余时长
var knockback_direction: Vector2 = Vector2.ZERO  # 击飞方向

func _ready() -> void:
	# 通过组查找玩家（确保玩家已添加 "player" 组）
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("警告：未找到玩家，请将玩家节点添加到 'player' 组。")
	ani_check()
func _process(delta: float) -> void:
	# 击飞阶段：只沿击飞方向位移，暂停追击与攻击
	if knockback_timer > 0.0:
		knockback_timer -= delta
		global_position += knockback_direction * knockback_force * delta
		if knockback_timer <= 0.0:
			hitted = false
		ani_check()
		return

	if player == null:
		return

	# 1. 更新攻击冷却
	if attack_timer > 0:
		attack_timer -= delta

	var distance = global_position.distance_to(player.global_position)
	# 3. 移动逻辑（如果距离大于追击范围，或小于停止距离，则停止移动）
	if distance > chase_range or distance < stop_distance:
		return

	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta

	if hitted:
		ani_check()
		return
	





func basic_attack(body: Node2D) -> void:
	print("attackedhere")
	if body is CharacterBody2D:
		var target = body as CharacterBody2D
		# 计算伤害值
		var damage = attack_value
		# target.health -= damage
		# #print("Slime攻击玩家，造成 %d 点伤害，玩家剩余血量: %d" % [damage, target.health])
		var knockback_direction = (target.global_position - global_position).normalized()
		# 击飞效果
# Slime 攻击代码
		if target != null and not target.is_queued_for_deletion():
			target.take_damage(damage)
  # 每次击退移动的距离
		for i in range(5):
			target.position += knockback_direction * knockback_force*0.2
		target.hitted=true
		await get_tree().create_timer(0.5).timeout
		if target != null and not target.is_queued_for_deletion():
			target.velocity=Vector2.ZERO
			target.move_and_slide()


func take_damage(amount: int) -> void:
	
	var effective_damage = max(amount - defense, 0)
	health -= effective_damage
	var number_instance = number.instantiate()
	number_instance.text = str(effective_damage)
	number_instance.global_position = global_position
	get_tree().current_scene.add_child(number_instance)
	hitted_out()  # 被攻击时触发击飞
	# print("Slime took ", effective_damage, " damage. Health now: ", health)
	if health <= 0:
		die()
	

func die() -> void:
	drop_item()
	var testpos = death_effect.instantiate()
	testpos.global_position = global_position
	get_tree().current_scene.add_child(testpos)
	# 在这里可以添加死亡动画或特效
	queue_free()

func ani_check() -> void:
	if hitted:
		# 播放被击中动画
		if $AnimatedSprite2D.animation != "hurted":
			$AnimatedSprite2D.play("hurted")
			await get_tree().create_timer(0.3).timeout
			$AnimatedSprite2D.play("default")
	else:
		if $AnimatedSprite2D.animation != "default":
			$AnimatedSprite2D.play("default")

func drop_item() -> void:
	
	var range111:Vector2
	for i in range(exp_number):
		var exp_instance = exp_drop_scene.instantiate()
		range111=Vector2(randf_range(-20,+20) , randf_range(-20,+20))
		exp_instance.global_position = global_position+range111
		#get_tree().current_scene.add_child(exp_instance)
		get_tree().current_scene.call_deferred("add_child", exp_instance)

func hitted_out() -> void:
	# 被攻击时沿远离攻击者（玩家）的方向击飞，持续一小段时间
	hitted = true
	var source = player if player != null else get_tree().get_first_node_in_group("player")
	if source != null:
		knockback_direction = (global_position - source.global_position).normalized()
	else:
		knockback_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	knockback_timer = knockback_time
