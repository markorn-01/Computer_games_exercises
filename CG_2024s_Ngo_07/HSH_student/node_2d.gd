# Name:        Quang Minh, Ngo;      student no.: 4742554
# Coauthor:    Taha Beytullah Erkoc; student no.: 4740805
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Node2D

# Reference paper:
#M. Eitz and G. Lixu, "\href{https://ieeexplore.ieee.org/document/4273369/}
#{Hierarchical Spatial Hashing for Real-time Collision Detection}," 
#\textit{IEEE International Conference on Shape Modeling and Applications 2007 (SMI '07)}, 
#Minneapolis, MN, USA, 2007, pp. 61-70, doi: 10.1109/SMI.2007.18.


# Called when the node enters the scene tree for the first time.
func _ready():
	map_segments_to_grid()
	update_hash_table()
	update_intersection_test()

# Update hash table whenever table size is changed	
func _on_edit_hash_text_submitted(_new_text):
	update_hash_table()
	
# Update potential point segment collisions whenever point is edited
func _on_edit_point_text_submitted(_new_text):
	$"Edit Point".text = str(abs(float($"Edit Point".text)))
	update_intersection_test()

# Update Segment mapping whenever segments are edited
func _on_edit_segments_lines_edited_from(from_line, to_line):
	map_segments_to_grid()
	update_hash_table()
	update_intersection_test()


# Update the hash table display
func update_hash_table():
	var hash_size = int($"Edit Hash Size".text)
	var grid_segments = map_segments_to_grid()
	var hash_table = put_segments_in_hash_table(grid_segments, hash_size)
	display_hash_table(hash_table)

# Update the intersection test result
func update_intersection_test():
	var point_pos = float($"Edit Point".text)
	var hash_size = int($"Edit Hash Size".text)
	var grid_segments = map_segments_to_grid()
	var hash_table = put_segments_in_hash_table(grid_segments, hash_size)
	var intersection_result = detect_intersections(point_pos, hash_table)
	$"Edit Intersection Result".text = intersection_result

# Function to extract the coordinates of the line segments.
# We use regular expressions, as its very difficult to
# extract the coordinates given the format of our input
func extract_coordinates(input_string):
	var result = []
	var regex = RegEx.new()
	regex.compile(r"([A-Z])\s*\(([0-9.]+),\s*([0-9.]+)\)")
	var matches = regex.search_all(input_string)

	for match in matches:
		var letter = match.get_string(1)
		var xmin = match.get_string(2).to_float()
		var xmax = match.get_string(3).to_float()
		result.append([letter, xmin, xmax])
	
	return result

# DJB2 hash function for 1D case
func djb2_hash(a, l, m):
	var hash = 5381
	hash = ((hash << 5) + hash) + a
	hash = ((hash << 5) + hash) + l
	return fmod(hash, m)

# Function to put line segments into the hash table
func put_segments_in_hash_table(segments, hash_size):
	var hash_table = {}
	for segment in segments:
		var letter = segment[0]
		var amin = segment[1]
		var amax = segment[2]
		var l = segment[3]
		for i in range(amin, amax + 1):
			var hash_value = djb2_hash(i, l, hash_size)
			if not hash_table.has(hash_value):
				hash_table[hash_value] = []
			hash_table[hash_value].append("%s (%d, %d)" % [letter, i, l])
	return hash_table
	
# Function to display the hash table result
func display_hash_table(hash_table):
	var result = ""
	for key in hash_table.keys():
		result += "Hash %d: " % key
		for entry in hash_table[key]:
			result += "%s, " % entry
		result += "\n"
	$"Edit Hash Result".text = result.strip_edges()
	

# Function to map coordinates to grid coordinates
func map_to_grid_coordinates(xmin, xmax):
	var s = xmax - xmin
	var l = max((log(s)/log(2)), 0)
	var k = pow(2, l)
	var amin = floor(xmin / k)
	var amax = floor(xmax / k)
	return [amin, amax, l]

# Function to display the grid cells
func display_grid_segments(grid, segments):
	for cell in grid.get_children():
		cell.text = ""
		
	for segment in segments:
		var letter = segment[0]
		var amin = segment[1]
		var amax = segment[2]
		var l = segment[3]
		for i in range(amin, amax + 1):
			var cell_name = "Cell %d %d" % [i, l]
			var cell = grid.get_node(cell_name)
			if cell:
				if cell.text != "":
					cell.text += ", "
				cell.text += letter

# Function to map the segments to the grid
func map_segments_to_grid():
	var input_string = $"Edit Segments".text
	var coordinates = extract_coordinates(input_string)
	var grid_segments = []

	for coord in coordinates:
		var letter = coord[0]
		var xmin = coord[1]
		var xmax = coord[2]
		var mapped_coords = map_to_grid_coordinates(xmin, xmax)
		var amin = mapped_coords[0]
		var amax = mapped_coords[1]
		var l = mapped_coords[2]
		grid_segments.append([letter, amin, amax, l])
	
	display_grid_segments($Grid, grid_segments)
	
	return grid_segments


# Detect intersections
# We again use regex to extract the amin and amix values from the segment string
# We check if point_pos lies within segment range and add it to segments_in_cell
# if it does
func detect_intersections(point_pos, hash_table):
	var result_text = ""
	for key in hash_table.keys():
		var segments_in_cell = []
		for segment in hash_table[key]:
			var regex = RegEx.new()
			regex.compile(r"\(([0-9]+), ([0-9]+)\)")
			var match = regex.search(segment)
			if match:
				var amin = int(match.get_string(1))
				var amax = int(match.get_string(2))
				if amin <= point_pos and point_pos <= amax:
					segments_in_cell.append(segment)
		if segments_in_cell.size() > 0:
			result_text += "| Hash value: %d | Cell index: %d | Segment list: %s |\n" % [key, key, str(segments_in_cell)]
	return result_text.strip_edges()
