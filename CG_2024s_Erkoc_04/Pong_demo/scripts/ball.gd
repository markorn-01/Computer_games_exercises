# Name:     Taha Beytullah Erkoc; student no.: 4740805
# Coauthor: Quang Minh, Ngo;      student no.: 4742554
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

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


# How are the actions of the ball implemented in this game? 
# (considering different cases in the game)

# Initially, we set the default speed and left direction for the ball. 
# Then, the speed is increased by 2 times delta for each frame 
# and the position is calculated based on new speed, delta, and new direction.
# When there is a player reaching 3 points in a game, direction of the ball is set to the middle
# and the speed of the ball is 0 (ball does not move).
# Otherwise, when the ball hits to the end of one of the walls, the ball is reset 
# which direction is set randomly to left or right and the speed is set to default again.
# Whether there is a player or not, the position of the ball is placd at the center of the panel.
# When the ball hits the paddles, the ball moves up or down randomly
# If the ball hits either the ceiling or the floor, it will be bounced.

# How is the scoring system implemented in this game?

# We can get the source which triggers _on_wall_area_entered(area)
# then we will update the label_point for the players and whenever there is a player gets 3 points
# the final result lable shows the name of the winner.


