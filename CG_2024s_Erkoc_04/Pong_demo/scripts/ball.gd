extends Area2D

const DEFAULT_SPEED = 100

var direction = Vector2.LEFT
var side = [Vector2.LEFT, Vector2.RIGHT]
@onready var _initial_pos = position
@onready var _speed = DEFAULT_SPEED

func _process(delta):
	_speed += delta * 2
	position += _speed * delta * direction


func reset():
	if (direction.x > 0):
		print(%LabelpointA)
		%LabelpointA.text = str(int(%LabelpointA.text) + 1)
	else:
		%LabelpointB.text = str(int(%LabelpointB.text) + 1)
	
	randomize() 
	direction = side[randi() % 2]
	position = _initial_pos
	_speed = DEFAULT_SPEED
