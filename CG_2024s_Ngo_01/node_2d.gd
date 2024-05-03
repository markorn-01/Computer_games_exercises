# Name: 	   Quang Minh, Ngo;      student no.: 4742554
# Coauthor:    Taha Beytullah Erkoc; student no.: 4740805
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Node2D

var counter = 0.0
var button_pressed
var counter_active
var panel
var label
var button

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the counter to disabled status
	counter_active = false
	
	# Set the status of button to False
	button_pressed = false
	
	# Create a Panel node
	panel = Panel.new()
	add_child(panel)

	# Set the size of the panel by setting the size property
	panel.size = Vector2(200, 200)
	
	# Create a Label node and add it to the Panel
	label = Label.new()
	label.text = "Hello!"
	panel.add_child(label)
	
	# Center the label to the panel
	label.position = Vector2((panel.size.x - label.size.x) / 2,
							 (panel.size.y - label.size.y) / 2)

	# Create a Button node and add it to the Panel
	button = Button.new()
	panel.add_child(button)
	button.connect("pressed", _on_button_pressed)
	
	
	# Set button size
	button.size = Vector2(50, 50)
	
	# Center the button to the panel and under the label
	button.position = Vector2((panel.size.x - button.size.x) / 2,
							 label.position.y + label.size.y)

func _on_button_pressed():
	# Set the button to be pressed at least once
	if not button_pressed:
		button_pressed = true
	
	# Switch the activate status of the counter
	counter_active = not counter_active

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if button_pressed and counter_active:
		counter += delta
		label.text = str(snapped(counter,0.01))

# Why is it important to know the time between two frames in a game?

# Understanding the time elapsed between two frames in a game ensures consistency regarding
# frame rates. It also ensures precise physics, animation and it enhances input responsiveness.
