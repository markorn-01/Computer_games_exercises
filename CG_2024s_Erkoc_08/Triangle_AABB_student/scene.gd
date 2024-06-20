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
	_drc_broad_phase()
	
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
	_drc_broad_phase()

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
			
func _drc_broad_phase():
	var triangles = [yellow, orange, red, blue, pink]
	var aabbs = []
	for triangle in triangles:
		var box = _get_points_aabb(triangle)
		aabbs.append([box[1], box[3]])
	
	var collisions = []
	for i in range(aabbs.size() - 1):
		for j in range(i + 1, aabbs.size()):
			if intersects(aabbs[i], aabbs[j]):
				collisions.append([aabbs[i], aabbs[j]])
	
	if collisions.size() > 0:
		print("Collisions detected:")
	else:
		print("No collisions detected.")
	
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
	
