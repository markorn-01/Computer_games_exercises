extends Area2D

const DEFAULT_SPEED = 100

var label_point_a
var label_point_b
var label_final
var direction = Vector2.LEFT
var side = [Vector2.LEFT, Vector2.RIGHT]
@onready var _initial_pos = position
@onready var _speed = DEFAULT_SPEED

var point_a: int

func _ready():
	label_point_a = get_node("../Panel/LabelpointA")
	label_point_b = get_node("../Panel/LabelpointB")
	label_final = get_node("../Panel/Labelfinal")

func _process(delta):
	_speed += delta * 2
	position += _speed * delta * direction


func reset():
	if direction.x > 0:
		label_point_a.text = str(int(label_point_a.text) + 1)
	else:
		label_point_b.text = str(int(label_point_b.text) + 1)
	
	if label_point_a.text == '3' or label_point_b.text == '3':
		direction = Vector2.ZERO
		position = _initial_pos
		_speed = 0
		if label_point_a.text == '3':
			label_final.text = "THE WINNER IS PLAYER A."
		else:
			label_final.text = "THE WINNER IS PLAYER B."
	else:
		randomize() 
		direction = side[randi() % 2]
		position = _initial_pos
		_speed = DEFAULT_SPEED
