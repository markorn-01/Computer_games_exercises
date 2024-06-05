extends Node2D
var param_V = 200
var param_T = 3

var nodeFollow
var nodeWall
var nodeSprite

var posOld
var posNew

var timeStart
var lastIntervalStart
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	nodeFollow = get_node("Path/CharacterFollow")
	nodeWall = get_node("Wall")
	nodeSprite = get_node("Path/CharacterFollow/Sprite2D")

	set_process(false)
	
func _on_Button_pressed():
	timeStart = Time.get_ticks_msec()
	nodeFollow.set_progress(0)
	lastIntervalStart = timeStart
	set_process(true)

func _process(delta):
	param_V = $Speed.value
	param_T = $Time.value
	
	# update the position / progress
	posOld = nodeSprite.to_global(nodeSprite.get_position())
	
	var progressNew = nodeFollow.get_progress() + param_V * delta
	nodeFollow.set_progress(progressNew)
	
	var currentTime = Time.get_ticks_msec()
	if (currentTime - lastIntervalStart) / 1000.0 >= param_T:
		if distance() <= 0:
			set_process(false)
			var fast_correction_t = fast_correction()
			var bisection_t = bisection()
			$FcValueLabel.text = str(snapped(fast_correction_t, 0.001))
			$BisectionValueLabel.text = str(snapped(bisection_t, 0.001))
		else:
			lastIntervalStart = currentTime
			record_actual()
	queue_redraw()
			

func _draw():
	var pos = nodeSprite.global_position
	draw_circle(pos, 5, Color(1, 0, 0))
	
func distance():
	var wall_left_pos = nodeWall.global_position.x - nodeWall.width/2
	var wall_right_pos = nodeWall.global_position.x + nodeWall.width/2 
	var wall_middle_pos = (wall_left_pos + wall_right_pos) / 2
	var obj_pos = nodeSprite.global_position.x
	if obj_pos <= wall_middle_pos:
		return wall_left_pos - obj_pos
	return obj_pos - wall_right_pos

func fast_correction():
	var t1 = (lastIntervalStart - timeStart) / 1000.0
	var d = distance_at_last_interval()
	return t1 + d / param_V

func bisection():
	var t1 = (lastIntervalStart - timeStart) / 1000.0
	var t2 = (Time.get_ticks_msec() - timeStart) / 1000.0 
	var t_tilda
	while abs(t1-t2) > param_T / 1000.0:
		t_tilda = (t1+t2) / 2.0
		nodeFollow.set_progress(t_tilda * param_V)
		if distance() < 0:
			t1 = t_tilda
		else:
			t2 = t_tilda
	return t1

func distance_at_last_interval():
	nodeFollow.set_progress((lastIntervalStart - timeStart) / 1000.0 * param_V)
	var distance_at_T1 = distance()
	nodeFollow.set_progress((Time.get_ticks_msec() - timeStart) / 1000.0 * param_V)
	return distance_at_T1

func record_actual():
	var actual_collision_time = (Time.get_ticks_msec() - timeStart) / 1000.0
	$ActualValueLabel.text = str(snapped(actual_collision_time, 0.001))

