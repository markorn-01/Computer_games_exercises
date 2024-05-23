extends Area2D

const DEFAULT_SPEED = 100

var label_point_a
var label_point_b

var direction = Vector2.LEFT
var side = [Vector2.LEFT, Vector2.RIGHT, Vector2.ZERO]
@onready var _initial_pos = position
@onready var _speed = DEFAULT_SPEED

var point_a: int

func _ready():
	label_point_a = get_node("../Panel/LabelpointA")
	label_point_b = get_node("../Panel/LabelpointB")

func _process(delta):
	_speed += delta * 2
	position += _speed * delta * direction


func reset():
	if label_point_a.text == '3' or label_point_b.text == '3':
		direction = side[2]
		_speed = 0
	else:
		randomize() 
		direction = side[randi() % 2]
		_speed = DEFAULT_SPEED
	position = _initial_pos
