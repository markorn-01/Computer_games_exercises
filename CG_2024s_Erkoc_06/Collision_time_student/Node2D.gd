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
	if posNew:
		draw_circle(posNew, 50, Color.RED)
	
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

