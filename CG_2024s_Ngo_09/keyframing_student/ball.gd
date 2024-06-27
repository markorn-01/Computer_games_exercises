extends Sprite2D

var waypoints = []
var derivatives = [
	Vector2(2, 0),
	Vector2(1, 2),
	Vector2(2, 1),
	Vector2(1, -2),
	Vector2(2, 0)
] 
var v = 10
var speed_slider
var mode_switch
var arc_length_label
var mode
var current = 0
var t = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	speed_slider = get_node("../panel12/HSlider")
	mode_switch = get_node("../panel12/OptionButton")
	arc_length_label = get_node("../panel12/Label")
	mode_switch.add_item("Hermite")
	mode_switch.add_item("Catmull-Rom")
	mode_switch.select(0)
	for child in get_parent().get_children():
		if child is Sprite2D and child.name.begins_with("sphere"):
			waypoints.append(child.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)

func _on_speed_slider_value_changed(value):
	v = value

func _on_mode_switch_item_selected(index):
	mode = mode_switch.get_item_text(index)

func hermite_spline(p0, p1, d0, d1, t):
	var h00 = 2 * pow(t, 3) - 3 * pow(t, 2) + 1
	var h10 = -2 * pow(t, 3) + 3 * pow(t, 2)
	var h01 = pow(t, 3) + 2 * pow(t, 2) + t
	var h11 = pow(t, 3) - pow(t, 2)
	return h00 * p0 + h10 * p1 + h01 * d0 + h11 * d1
	
func catmull_rom_spline():
	var list_d = []
	# add the first waypoint
	list_d.append(Vector2(10, 0))
	
	for idx in range(1, waypoints.size()-1):
		list_d.append(0.5 * (waypoints[idx+1] - waypoints[idx-1]))
		
	# add the first waypoint
	list_d.append(Vector2(10, 0))
	return list_d

func arc_length(p0, p1, d0, d1):
	var steps = 10
	var length = 0.0
	var prev_point = p0
	for i in range(1, steps + 1):
		var t = float(i) / steps
		var point = hermite_spline(p0, p1, d0, d1, t)
		var distance = prev_point.distance_to(point)
		arc_length_label.text = "Arc Length: " + str(snapped(distance, 0.001))
		length += distance
		prev_point = point
		return length


func move(delta):
	if mode == "Catmull-Rom":
		derivatives = catmull_rom_spline()
	
	var p0 = waypoints[current]
	var p1 = waypoints[(current + 1) % waypoints.size()]
	var d0 = derivatives[current]
	var d1 = derivatives[(current + 1) % waypoints.size()]
	var l_piece = arc_length(p0, p1, d0, d1)
	var t_piece = l_piece / v
	
	t += delta / t_piece
	
	if t > 1.0:
		t -= 1.0
		current = (current + 1) % waypoints.size()
	
	position = hermite_spline(p0, p1, d0, d1, t)
	if current == 0:
		arc_length_label.text = "Arc Length: " + "0"
