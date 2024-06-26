# Name:     Taha Beytullah Erkoc; student no.: 4740805
# Coauthor: Quang Minh, Ngo;      student no.: 4742554
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Area2D

const MOVE_SPEED = 100

var _ball_dir
var _up
var _down
var origin_pos
@onready var _screen_size_y = get_viewport_rect().size.y

func _ready():
	var n = name.to_lower()
	print(n)
	_up = n + "_move_up"
	_down = n + "_move_down"
	_ball_dir = 1 if n == "left" else -1
	origin_pos = position.y

func _process(delta):
	# Move up and down based on input.
	var input = Input.get_action_strength(_down) - Input.get_action_strength(_up)
	print(Input.get_action_strength(_up))
	# Since the scene's height was originally 400 and increased to 500 later, the maximum should be -100
	position.y = clamp(position.y + input * MOVE_SPEED * delta, 16, _screen_size_y - 16 - 100)

func reset():
	position.y = origin_pos
	#pass

func _on_area_entered(area):
	if area.name == "Ball":
		# Assign new direction.
		area.direction = Vector2(_ball_dir, randf() * 2 - 1).normalized()
