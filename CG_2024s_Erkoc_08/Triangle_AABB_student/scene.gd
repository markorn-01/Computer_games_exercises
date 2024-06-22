# Name:        Taha Beytullah Erkoc; student no.: 4740805
# Coauthor:    Quang Minh, Ngo;      student no.: 4742554
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Node2D

var runSpeed = 500
var yellow
var orange
var red
var blue
var pink
var max_val = 500
var min_val = 0

var rng = RandomNumberGenerator.new()

func randomize_vertices(triangle):
	rng.randomize()
	triangle.polygon[0][0] = rng.randi_range(min_val, max_val)
	triangle.polygon[0][1] = rng.randi_range(min_val, max_val)
	
	triangle.polygon[1][0] = rng.randi_range(min_val, max_val)
	triangle.polygon[1][1] = rng.randi_range(min_val, max_val)
	
	triangle.polygon[2][0] = rng.randi_range(min_val, max_val)
	triangle.polygon[2][1] = rng.randi_range(min_val, max_val)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	yellow = get_node("Yellow")
	orange = get_node("Orange")
	red = get_node("Red")
	blue = get_node("Blue")
	pink = get_node("Pink")
	
	randomize_vertices(yellow)
	randomize_vertices(orange)
	randomize_vertices(red)
	randomize_vertices(blue)
	randomize_vertices(pink)
	
	yellow.color = Color(1, 1, 1, 0)
	orange.color = Color(1, 1, 1, 0)
	red.color = Color(1, 1, 1, 0)
	blue.color = Color(1, 1, 1, 0)
	pink.color = Color(1, 1, 1, 0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func _on_Button_pressed():
	randomize_vertices(yellow)
	randomize_vertices(orange)
	randomize_vertices(red)
	randomize_vertices(blue)
	randomize_vertices(pink)
	
	yellow.color = Color(1, 1, 1, 0)
	orange.color = Color(1, 1, 1, 0)
	red.color = Color(1, 1, 1, 0)
	blue.color = Color(1, 1, 1, 0)
	pink.color = Color(1, 1, 1, 0)
	queue_redraw()
	$ButtonYellow.set_pressed(false)
	$ButtonOrange.set_pressed(false)
	$ButtonPink.set_pressed(false)
	$ButtonBlue.set_pressed(false)
	$ButtonRed.set_pressed(false)

#------------------------------------------------------------------------------------------------
# Get 4 corners of the bounding box
func get_points_aabb(triangle):
	var x_min = max_val
	var x_max = min_val
	var y_min = max_val
	var y_max = min_val
	var triangle_global_position = triangle.global_position
	for vertex in triangle.polygon:
		x_min = min(x_min, vertex.x)
		x_max = max(x_max, vertex.x)
		y_min = min(y_min, vertex.y)
		y_max = max(y_max, vertex.y)
	var left_top = Vector2(x_min, y_max) + triangle_global_position
	var left_bot = Vector2(x_min, y_min) + triangle_global_position
	var right_top = Vector2(x_max, y_max) + triangle_global_position
	var right_bot = Vector2(x_max, y_min) + triangle_global_position
	return [left_top, left_bot, right_bot, right_top]

#------------------------------------------------------------------------------------------------
# Draw AABB with dashed lines
# Function to draw a dashed line between two points
func _draw_dashed_line(from: Vector2, to: Vector2, color: Color, dash_length: float = 10.0, space_length: float = 5.0):
	var total_length = from.distance_to(to)
	var direction = (to - from).normalized()
	var current_position = from
	var drawing = true
	while current_position.distance_to(from) < total_length:
		if drawing:
			var segment_length = min(dash_length, current_position.distance_to(to))
			var end_position = current_position + direction * segment_length
			draw_line(current_position, end_position, color, 1)
			current_position = end_position
		else:
			current_position += direction * space_length
		drawing = !drawing

func _draw():
	var triangles = [yellow, orange, red, blue, pink]
	for triangle in triangles:
		var points = get_points_aabb(triangle)
		var color = Color(1, 1, 1) # White color
		# Draw dashed lines connecting the points
		for i in range(points.size()):
			var next_index = (i + 1) % points.size()
			_draw_dashed_line(points[i], points[next_index], color, 10, 5)

#------------------------------------------------------------------------------------------------
# Dimension Reduction Collision
func drc_broad_phase(target):
	var triangles = [yellow, orange, red, blue, pink]
	var aabbs = []	
	for i in triangles.size():
		if triangles[i] == target:
			triangles.remove_at(i)
			break
	
	for triangle in triangles:
		var box = get_points_aabb(triangle)
		aabbs.append([box[1], box[3]])
		
	var target_box = get_points_aabb(target)
	var target_aabb = [target_box[1], target_box[3]]
	
	
	var collisions = []
	for i in range(aabbs.size()):
		if interval_intersect(target_aabb, aabbs[i]):
			collisions.append(triangles[i])
	
	if collisions.size() > 0:
		for collision in collisions:
			collision.color = Color.BLACK
		var narrow_phase = triangles_intersect(target)
		if narrow_phase.size() > 0:
			for narrow in narrow_phase:
				narrow.color = Color.WHITE
		
	
	
func interval_intersect(aabb1, aabb2) -> bool:
	for axis in range(2):
		var this_interval_min = aabb1[0][axis]
		var this_interval_max = aabb1[1][axis]
		var other_interval_min = aabb2[0][axis]
		var other_interval_max = aabb2[1][axis]
		if this_interval_max < other_interval_min or other_interval_max < this_interval_min:
			# No overlap in this dimension, hence no collision
			return false
	# Overlaps in all dimensions, collision detected
	return true
#------------------------------------------------------------------------------------------------
func _on_Button_Color_pressed(color):
	var dic = {
		"Yellow": yellow,
		"Orange": orange,
		"Red": red,
		"Blue": blue,
		"Pink": pink
	}
	yellow.color = Color(1, 1, 1, 0)
	orange.color = Color(1, 1, 1, 0)
	red.color = Color(1, 1, 1, 0)
	blue.color = Color(1, 1, 1, 0)
	pink.color = Color(1, 1, 1, 0)
	drc_broad_phase(dic[color])
#------------------------------------------------------------------------------------------------
# Triangle-Triangle Test
# Function to calculate the normal of a 3D triangle
# In 2D context, this function may return a scalar representing the 2D cross product (area of the parallelogram)
# Function to determine the orientation of three points
func point_orientation(p, q, r):
	var val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
	if val == 0:
		return 0
	return 1 if val > 0 else -1

# Function to check if two segments intersect
func segment_intersect(p1, q1, p2, q2):
	var o1 = point_orientation(p1, q1, p2)
	var o2 = point_orientation(p1, q1, q2)
	var o3 = point_orientation(p2, q2, p1)
	var o4 = point_orientation(p2, q2, q1)
	return o1 != o2 and o3 != o4

func triangle_sign(p1, p2, p3):
	return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
# Function to check if a point is inside a triangle
func is_point_in_triangle(pt, v1, v2, v3):	
	var d1 = triangle_sign(pt, v1, v2)
	var d2 = triangle_sign(pt, v2, v3)
	var d3 = triangle_sign(pt, v3, v1)
	var has_neg = (d1 < 0) or (d2 < 0) or (d3 < 0)
	var has_pos = (d1 > 0) or (d2 > 0) or (d3 > 0)
	return not (has_neg and has_pos)

# Function to check if two triangles intersect
func triangles_intersect(target):
	var target_global_position = target.global_position
	var triangles = [yellow, orange, red, blue, pink]
	var collisions = []
	for i in triangles.size():
		if triangles[i] == target:
			triangles.remove_at(i)
			break
	var A1 = target.polygon[0] + target_global_position
	var B1 = target.polygon[1] + target_global_position
	var C1 = target.polygon[2] + target_global_position
	for triangle in triangles:
		var triangle_global_position = triangle.global_position
		var A2 = triangle.polygon[0] + triangle_global_position
		var B2 = triangle.polygon[1] + triangle_global_position
		var C2 = triangle.polygon[2] + triangle_global_position
		# Check if any edge of triangle 1 intersects with any edge of triangle 2
		if (segment_intersect(A1, B1, A2, B2) or segment_intersect(A1, B1, B2, C2) or segment_intersect(A1, B1, C2, A2) or
			segment_intersect(B1, C1, A2, B2) or segment_intersect(B1, C1, B2, C2) or segment_intersect(B1, C1, C2, A2) or
			segment_intersect(C1, A1, A2, B2) or segment_intersect(C1, A1, B2, C2) or segment_intersect(C1, A1, C2, A2)):
				collisions.append(triangle)
				continue
		
		# Check if any vertex of one triangle is inside the other triangle
		if (is_point_in_triangle(A1, A2, B2, C2) or is_point_in_triangle(B1, A2, B2, C2) or is_point_in_triangle(C1, A2, B2, C2) or
			is_point_in_triangle(A2, A1, B1, C1) or is_point_in_triangle(B2, A1, B1, C1) or is_point_in_triangle(C2, A1, B1, C1)):
				collisions.append(triangle)
	
	return collisions



# The complete collision detection pipeline
# Broad phase:
# 1. In the broad phase, we create the AABBs for each triangle based on the max and
#    min of their x and y coordinates. That means, we get four corners of the AABBs, which are
#    top left (xmin, ymax), bottom left (xmin, ymin), bottom right (xmax, ymin),
#    top right (xmax, ymax).
#
# 2. Next, we implement the interval intersections for the x and y dimensions. We check
#    whether there is a collision in both dimensions. If there is, that means a collision
#    is detected.
#
# Narrow phase:
# In the narrow phase, there are two subcases, which are the segment intersection and is_point_in_triangle.
# 1. Edge-Edge Intersection Test: For each edge of the first triangle, check if it intersects with any edge
#    of the second triangle. If it does, it means, there's a collision.
#
# 2. Point inside Triangle Test: If no intersections are found in the previous step, we 
#    check if any points of one triangle are inside the other triangle. If so, it means
#    we have a collision.

