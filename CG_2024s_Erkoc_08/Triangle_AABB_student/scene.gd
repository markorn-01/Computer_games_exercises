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
	test_all_triangle_intersections()
	$ButtonYellow.set_pressed(false)
	$ButtonOrange.set_pressed(false)
	$ButtonPink.set_pressed(false)
	$ButtonBlue.set_pressed(false)
	$ButtonRed.set_pressed(false)

#------------------------------------------------------------------------------------------------
# Get 4 corners of the bounding box
func _get_points_aabb(triangle):
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
		var points = _get_points_aabb(triangle)
		var color = Color(1, 1, 1) # White color
		# Draw dashed lines connecting the points
		for i in range(points.size()):
			var next_index = (i + 1) % points.size()
			_draw_dashed_line(points[i], points[next_index], color, 10, 5)

#------------------------------------------------------------------------------------------------
# Dimension Reduction Collision
func _drc_broad_phase(target):
	var triangles = [yellow, orange, red, blue, pink]
	var aabbs = []	
	for i in triangles.size():
		if triangles[i] == target:
			triangles.remove_at(i)
			break
	
	for triangle in triangles:
		var box = _get_points_aabb(triangle)
		aabbs.append([box[1], box[3]])
		
	var target_box = _get_points_aabb(target)
	var target_aabb = [target_box[1], target_box[3]]
	
	
	var collisions = []
	for i in range(aabbs.size()):
		if intersects(target_aabb, aabbs[i]):
			collisions.append(triangles[i])
	
	if collisions.size() > 0:
		for collision in collisions:
			collision.color = Color.BLACK
	
	
func intersects(aabb1, aabb2) -> bool:
	for axis in range(2): # Assuming 2D, adjust for 3D if needed
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
	_drc_broad_phase(dic[color])
#------------------------------------------------------------------------------------------------
# Triangle-Triangle Test
# Function to calculate the normal of a 3D triangle
# In 2D context, this function may return a scalar representing the 2D cross product (area of the parallelogram)
func calculate_triangle_normal(v1: Vector2, v2: Vector2, v3: Vector2) -> float:
	var vector1 = v2 - v1
	var vector2 = v3 - v1
	return vector1.cross(vector2)  # This is the 2D "normal"

# Function to calculate the intersection line between two triangles
func calculate_intersection_line(triangle1: PackedVector2Array, triangle2: PackedVector2Array) -> Array:
	var normal1 = calculate_triangle_normal(triangle1[0], triangle1[1], triangle1[2])
	var normal2 = calculate_triangle_normal(triangle2[0], triangle2[1], triangle2[2])

	if normal1 == 0 or normal2 == 0:
		# If either normal is zero, the triangles are degenerate (collinear points)
		return []
	
	var direction = Vector2(-normal2, normal1).normalized()  # Use the 2D perpendicular vector as the direction
	var point_on_line = triangle1[0]  # Choose a point on the line (e.g., vertex of triangle1)
	
	# Return a line segment (or ray) representing the intersection line
	return [point_on_line, point_on_line + direction * 1000]  # Adjust length as needed

# Function to project a point onto a line defined by a point and direction
func project_point_on_line(point: Vector2, point_on_line: Vector2, direction: Vector2) -> float:
	return (point - point_on_line).dot(direction)

# Function to project a triangle onto a line defined by a point and direction
func project_triangle_on_line(triangle: PackedVector2Array, point_on_line: Vector2, direction: Vector2) -> Vector2:
	var min_interval = project_point_on_line(triangle[0], point_on_line, direction)
	var max_interval = min_interval
	for i in range(1, triangle.size()):
		var projection = project_point_on_line(triangle[i], point_on_line, direction)
		min_interval = min(min_interval, projection)
		max_interval = max(max_interval, projection)
	return Vector2(min_interval, max_interval)

# Function to check if two intervals overlap
func intervals_overlap(interval1: Vector2, interval2: Vector2) -> bool:
	return interval1.y >= interval2.x and interval2.y >= interval1.x

# Function to perform triangle-triangle intersection test
func triangle_triangle_intersect(triangle1: PackedVector2Array, triangle2: PackedVector2Array) -> bool:
	# Step 1: Calculate the intersection line
	var intersection_line = calculate_intersection_line(triangle1, triangle2)
	
	if intersection_line.size() == 0:
		# No valid intersection line
		return false
	
	var point_on_line = intersection_line[0]
	var direction = (intersection_line[1] - intersection_line[0]).normalized()
	
	# Step 2: Project both triangles onto the intersection line
	var interval1 = project_triangle_on_line(triangle1, point_on_line, direction)
	var interval2 = project_triangle_on_line(triangle2, point_on_line, direction)
	
	# Step 3: Check if intervals overlap
	return intervals_overlap(interval1, interval2)

# Function to perform the test for all pairs of triangles
func test_all_triangle_intersections() -> bool:
	var triangles = [yellow, orange]
	for i in range(triangles.size() - 1):
		for j in range(i + 1, triangles.size()):
			var triangle1 = triangles[i].polygon
			var triangle2 = triangles[j].polygon
			if triangle_triangle_intersect(triangle1, triangle2):
				return true
	return false
