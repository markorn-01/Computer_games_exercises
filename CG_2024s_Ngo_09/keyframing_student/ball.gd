# Name:        Quang Minh, Ngo;      student no.: 4742554
# Coauthor:    Taha Beytullah Erkoc; student no.: 4740805
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Sprite2D

var waypoints = []
var derivatives
var original_derivatives = [
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
var mode = "Hermite"
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
	mode = mode_switch.get_item_text(0)
	update_derivatives()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)

func _on_speed_slider_value_changed(value):
	v = value

func _on_mode_switch_item_selected(index):
	mode = mode_switch.get_item_text(index)
	update_derivatives()
	
func update_derivatives():
	if mode == "Catmull-Rom":
		derivatives = catmull_rom_derivatives()
	else:
		# Reset to initial derivatives if switching back to Hermite
		derivatives = original_derivatives

func hermite_spline(p0, p1, d0, d1, t):
	var h00 = 2 * pow(t, 3) - 3 * pow(t, 2) + 1
	var h10 = -2 * pow(t, 3) + 3 * pow(t, 2)
	var h01 = pow(t, 3) - 2 * pow(t, 2) + t
	var h11 = pow(t, 3) - pow(t, 2)
	return h00 * p0 + h10 * p1 + h01 * d0 + h11 * d1
	
func catmull_rom_spline(t: float, p0: Vector2, p1: Vector2, p2, p3) -> Vector2:
	var d1 = 0.5 * (p2 - p0)
	var d2 = 0.5 * (p3 - p1)
	return hermite_spline(p1, p2, d1, d2, t)


func catmull_rom_derivatives():
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
		length += distance
		prev_point = point
	return length


func move(delta):
	
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
	
	if mode == "Hermite":
		position = hermite_spline(p0, p1, d0, d1, t)
	elif mode == "Catmull-Rom":
		var prev_point = waypoints[(current - 1 + waypoints.size()) % waypoints.size()]
		var next_point = waypoints[(current + 2) % waypoints.size()]
		position = catmull_rom_spline(t, prev_point, p0, p1, next_point)

	# Calculate the total arc length up to the current position
	var total_arc_length = 0.0
	for i in range(current):
		total_arc_length += arc_length(waypoints[i], waypoints[(i + 1) % waypoints.size()], derivatives[i], derivatives[(i + 1) % waypoints.size()])
	total_arc_length += arc_length(p0, p1, d0, d1) * t
	
	arc_length_label.text = "Arc Length: " + str(snapped(total_arc_length, 0.01))
	
# The extension of keyframing to a deformable object is realized via free-form deformation.
# In contrast, for physics-based animation, the procedure is automatic and completely defined
# by the applied forces to the object under investigation.
# How can keyframing be transferred to physics-based animation henceforth?

# We can define the keyframes as target states or constraints within the physics simulation.
# The physics engine can then use forces and constraints to transition the object from one keyframe
# to the next, maintaining physical realism while achieving the desired animation path.

