extends CanvasLayer
@export var health:int=200
@export var exp:int=0
@export var level:int=1
@export var level_maxvalue:int=100

@export var testHP:Label
@export var testEXP:Label
@export var testLevel:Label
# @export(type,other_configs) var name = default setget 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_ui(health, exp, level, level_maxvalue)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	refresh_ui(health, exp, level, level_maxvalue)



func refresh_ui(new_health: int, new_exp: int, new_level: int, new_level_maxvalue: int) -> void:
	health = new_health
	exp = new_exp
	level = new_level
	level_maxvalue = new_level_maxvalue

	#$HP_number/label.text = str(health)
	#$EXP_number/label.text = str(exp)
	#$Level_number/label.text = str(level)+"/"+str(level_maxvalue)
	testHP.text=str(health)
	testEXP.text=str(exp)+"/"+str(level_maxvalue)
	testLevel.text= str(level)
	
