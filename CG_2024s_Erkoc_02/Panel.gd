# Name:     Taha Beytullah Erkoc; student no.: 4740805
# Coauthor: Quang Minh, Ngo;      student no.: 4742554
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Panel

# Define dictionaries to map state names and colors to integer values
const STATES = {"BED": 0, "HOME": 1, "WORK": 2}
const COLORS = {0: Color.GREEN , 1: Color.BLUE, 2: Color.RED}

# Initially, set the current state to "HOME"
var curr_state = STATES["HOME"]

# Create variable to import the attached label
var label

# Called when the node enters the scene tree for the first time.
# Assign the attached label to variable
func _ready():
	label = get_node("Label")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check for action presses and change the state accordingly
	# Implement the state machine s.t you can't go to bed directly from work
	# or vice versa
	if curr_state == STATES["HOME"]:
		if Input.is_action_pressed("B"):
			curr_state = STATES["BED"]
		elif Input.is_action_pressed("W"):
			curr_state = STATES["WORK"]
	else:
		if Input.is_action_pressed("H"):
			curr_state = STATES["HOME"]
			
	# Update the label text according to the current state
	label.text = STATES.find_key(curr_state)
	queue_redraw()
	

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size), COLORS.get(curr_state))
	

# How did you come to this implementation?
#
# This implementation uses a dictionary (STATES) to map state names (e.g., "BED", "HOME", "WORK") to integer values.
# The current state is tracked using a variable (curr_state) which is updated based on key presses ('H', 'W', 'B').
# The _process() function continuously checks for key presses and updates the current state and panel color accordingly.
# The Label text is updated to display the current state using the STATES dictionary as well.

# What could be further improved for this implementation when there are more than 100 states?
#
# When dealing with a large number of states, using a dictionary lookup-based approach might be inefficient
# regarding speed and memory efficiency. In such cases, using an array with indexing for each of its element
# would be a more optimal solution. 
# For example: 
# STATES = ["BED", "HOME", "WORK"]
# COLORS = [Color.GREEN, Color.BLUE, Color.RED]
# curr_state_idx = 0
# then using STATES[curr_state_idx] and COLORS[curr_state_idx] to access each elements in those arrays
#
# Moreover, a design pattern like Finite State Machine can be applied to better organize logic 
# and maintain code easily.
