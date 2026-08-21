extends Sprite2D

@export var swing_angle: float = 4.0
@export var swing_speed: float = 0.8
@export var drift_strength: float = 6.0
@export var drift_speed: float = 0.9
@export var base_scale: Vector2 = Vector2(1.2, 1.2)

var time: float = 0.0

func _ready() -> void:
	self.centered = true
	self.scale = base_scale
	self.rotation = deg_to_rad(2.0)

func _process(delta: float) -> void:
	time += delta

	# 轻微往复摆动，像背景在轻轻晃动
	var swing = sin(time * swing_speed) * deg_to_rad(swing_angle)
	self.rotation = swing + deg_to_rad(2.0)

	# 让位置做小幅循环移动，但保持柔和
	var x_offset = sin(time * drift_speed) * drift_strength
	var y_offset = cos(time * drift_speed * 0.8) * (drift_strength * 0.4)
	self.position = Vector2(x_offset, y_offset)

	# 极轻微的呼吸感
	var pulse = 1.0 + sin(time * 1.2) * 0.015
	self.scale = base_scale * pulse
