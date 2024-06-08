# Name:        Taha Beytullah Erkoc; student no.: 4740805
# Coauthor:    Quang Minh, Ngo;      student no.: 4742554
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science
extends Node2D
var param_V = 200
var param_T = 3

var nodeFollow
var nodeWall
var nodeSprite

var posOld
var posNew

var timeStart
var T1
var T2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	nodeFollow = get_node("Path/CharacterFollow")
	nodeWall = get_node("Wall")
	nodeSprite = get_node("Path/CharacterFollow/Sprite2D")
	
	set_process(false)
	
func _on_Button_pressed():
	timeStart = Time.get_ticks_msec()
	nodeFollow.set_progress(0)
	T1 = 0
	posNew = nodeSprite.to_global(nodeSprite.get_position())
	posOld = posNew
	queue_redraw()
	$ActualValueLabel.text = "(s)"
	$FcValueLabel.text = "(s)"
	$BisectionValueLabel.text = "(s)"
	set_process(true)

func _process(delta):
	param_V = $Speed.value
	param_T = $Time.value
	
	var progressNew = nodeFollow.get_progress() + param_V * delta
	nodeFollow.set_progress(progressNew)
	
	# get current position
	posNew = nodeSprite.to_global(nodeSprite.get_position())
	
	T2 = (Time.get_ticks_msec() - timeStart) / 1000.0
	var currentTimeInterval = T2 - T1
	if  currentTimeInterval >= param_T:
		# collision detected
		if distance(posNew.x) <= 0:
			set_process(false)
			var fast_correction_t = fast_correction()
			var bisection_t = bisection()
			$FcValueLabel.text = str(snapped(fast_correction_t, 0.001))
			$BisectionValueLabel.text = str(snapped(bisection_t, 0.001))
		# no collision detected
		else:
			# set T2 as the beginning time T1 for next interval
			T1 = T2
			queue_redraw()
		# update the position / progress
		posOld = posNew
		record_actual()
			
func _draw():
	var pos = nodeSprite.to_global(nodeSprite.get_position())
	draw_circle(pos, 50, Color.RED)
	
func distance(x_object):
	var x_wall_middle = nodeWall.points[0].x
	var x_wall_left = x_wall_middle - nodeWall.width/2
	var x_wall_right = x_wall_middle + nodeWall.width/2 
	if x_object <= x_wall_middle:
		return x_wall_left - x_object
	else:
		return x_object - x_wall_right

func fast_correction():
	return T1 + distance(posOld.x) / param_V

func bisection():
	var t1 = T1
	var t2 = T2
	var t_tilda
	var x_t_tilda
	var initial_pos = nodeFollow.get_progress()
	while abs(t1-t2) > param_T / 1000:
		t_tilda = (t1+t2) / 2.0
		nodeFollow.set_progress(t_tilda * param_V)
		x_t_tilda = nodeSprite.to_global(nodeSprite.get_position()).x
		if distance(x_t_tilda) < 0:
			t1 = t_tilda
		else:
			t2 = t_tilda
	nodeFollow.set_progress(initial_pos)
	return t1

func record_actual():
	if distance(posNew.x) < 0:
		var actual_collision_time = (Time.get_ticks_msec() - timeStart) / 1000.0
		$ActualValueLabel.text = str(snapped(actual_collision_time, 0.001))

# With which interval T the collision may not be detected when speed V = 2000 pixel/s?

# In our case, with interval T = 0.1s, 0.4s, 0.5s, >= 0.7s, the collision is not
# detected.

# When the object may be overseen, which strategy has to be used instead?

# We could adopt a sub-interval strategy where we break down the interval T
# into smaller sub-intervals and perform collision detection at each sub-interval
# ensuring that the object does not move beyond the width of the wall.

# In the lecture you learned that we have a broad and narrow phase: Could you
# improve the collision time estimate via bisection using these two phases? What is
# the expected gain in performance on average?

# In collision detection, the broad phase quickly eliminates pairs of objects
# that cannot possibly collide, and the narrow phase performs precise collision
# detection on the remaining pairs.
# In our bisection method, we could quickly determine if there is a potential for
# collision within the interval using a simple bounding box check.
# If the bounding box of the object intersects with the wall's bounding box,
# we proceed to the narrow phase, where we perform the precise collision detection
# using the bisection method only if the broad phase indicates a potential collision.
# 
# By introducing these two phases, we can reduce the number of times where the bisection
# method needs to be performed, saving computational resources.
# The expected gain in performance will depend on how many intervals the broad phase can eliminate,
# even though it is clear, that the performance can improve significantly.
