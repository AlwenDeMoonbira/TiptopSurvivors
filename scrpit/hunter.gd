extends CharacterBody2D
@export var health:int=200
@export var defense:int=0
@export var strength:int=1
@export var movement_speed: float = 200.0
@export var jump_force: float = 400.0      # 如不需要跳跃可删除
@export var long_press_time: float = 0.5   # 暂未使用
@export var long_press_radius: float = 500.0
@export var hitted:bool =false
@export var level:int=0
@export var exp:int=0
@export var explist: Array = [0, 100, 300, 600, 1000, 2000, 3000, 4000,5000,6000] # 每级所需经验值列表
# 移动状态
@export var number: PackedScene  # 用于显示伤害数字的场景，确保在场景树中存在
@export var death_effect: PackedScene  # 用于死亡时的特效节点，确保在场景树中存在
@export var test_effect: PackedScene  # 用于击中时的特效节点，确保在场景树中存在
var is_moving: bool = false
var target_global_position: Vector2 = Vector2.ZERO   # 全局目标坐标
@onready var _anim_sprite = $SpritePivot/AnimatedSprite2D
@onready var sprite_pivot = $SpritePivot
@export var player_number=0
func _ready() -> void:
	pass
func _input(event: InputEvent) -> void:
	# 移动端：触摸屏幕任意位置即点击移动
	if event is InputEventScreenTouch and event.pressed:
		# 将屏幕坐标转换为世界坐标（相机可能有移动/缩放）
		var world_pos = get_canvas_transform().affine_inverse() * event.position
		_set_move_target(world_pos)
		return
	# 桌面端：鼠标左键点击移动
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_set_move_target(get_global_mouse_position())

func _set_move_target(target_pos: Vector2) -> void:
	# 点击位置在角色周围半径内才开始移动
	if target_pos.distance_to(global_position) < long_press_radius:
		target_global_position = target_pos
		is_moving = true

func _physics_process(delta: float) -> void:
	if not is_moving or hitted:
		hitted = false
		velocity=Vector2.ZERO
		move_and_slide()
		return
	
	# 计算指向目标的方向向量
	var direction = (target_global_position - global_position).normalized()
	var distance = global_position.distance_to(target_global_position)
	
	# 如果距离非常小，直接到达并停止
	if distance < movement_speed * delta:
		global_position = target_global_position
		velocity = Vector2.ZERO
		is_moving = false
		move_and_slide()
		return
	
	# 否则以全速移动
	velocity = direction * movement_speed
	move_and_slide()

	# 更新动画状态
func _process(delta: float) -> void:
	_update_animation()

func _update_animation() -> void:
	if hitted:
		if _anim_sprite.animation != "hit":
			var hit_instance = test_effect.instantiate()  # 创建击中特效的实例
			hit_instance.global_position = global_position  # 将特效位置设置为角色当前位置
			get_tree().current_scene.add_child(hit_instance)  # 确保动画节点在场景树中
			hitted = false  # 播放一次后重置状态
	else:

		if _anim_sprite == null:
			return
		if is_moving:
			if _anim_sprite.animation != "run":
				_anim_sprite.play("run")
		else:
			if _anim_sprite.animation != "idle":
				_anim_sprite.play("idle")
		if is_moving and velocity.length() > 0.1:
			if velocity.x > 0:
				sprite_pivot.scale.x = 1   # 朝右
			elif velocity.x < 0:
				sprite_pivot.scale.x = -1  # 朝左

#func take_damage(amount: int) -> void:
	#var effective_damage = max(amount - defense, 0)
	#health -= effective_damage
	#print("Hunter took ", effective_damage, " damage. Health now: ", health)
	#
	#if health == 0:
		#print("testoutput")
		#die114()
func take_damage(amount: int) -> void:
	# print("=== take_damage 被调用 ===")
	# print("进入时 health = ", health)
	var effective_damage = max(amount - defense, 0)
	# print("实际伤害 = ", effective_damage)
	health -= effective_damage
	
	var number_instance = number.instantiate()
	number_instance.text = str(effective_damage)
	number_instance.global_position = global_position
	get_tree().current_scene.add_child(number_instance)
	
	
	
	
	print("扣血后 health = ", health)
	if health <= 0:
		# print("✅ 条件成立，即将调用 die()")
		die()
	get_node("/root/ms").set_health(health)
	var hit_instance = test_effect.instantiate()  # 创建击中特效的实例
	hit_instance.global_position = global_position  # 将特效位置设置为角色当前位置
	get_tree().current_scene.add_child(hit_instance)  # 确保动画节点在




func hitted_out (vector: Vector2,knockback_strength: float) -> void:
	is_moving = false
	velocity = Vector2.ZERO
	
	# 重置目标位置为当前位置，防止残留目标导致下次意外移动
	target_global_position = global_position
	# 可选：强制立即更新一次动画（下一帧 _process 会自动处理）
	hitted = true
	# 如果希望立即切换动画，可以调用 _update_animation()，但非必须

func die() -> void: 
	print("player has died")
	var death_instance = death_effect.instantiate()  # 创建死亡特效的实例
	death_instance.global_position = global_position 
	get_tree().current_scene.add_child(death_instance)
	
	  # 将特效添加到当前
	# get_tree().current_scene.add_child(PackedScene.new().instance())  # 替换为实际的死亡处理逻辑，例如播放死亡动画、掉落物品等
	queue_free()  # 删除当前节点
	print("Hunter has died.")
