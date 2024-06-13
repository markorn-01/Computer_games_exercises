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

func _on_edit_hash_text_submitted(_new_text):
	$"Edit Hash".text = str(abs(int($"Edit Hash".text)))


func _on_edit_point_text_submitted(_new_text):
	$"Edit Point".text = str(abs(float($"Edit Point".text)))



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


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


func _on_edit_segments_lines_edited_from(from_line, to_line):
	map_segments_to_grid()
