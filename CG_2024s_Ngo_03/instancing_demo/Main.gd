# Name: 	   Quang Minh, Ngo;      student no.: 4742554
# Coauthor:    Taha Beytullah Erkoc; student no.: 4740805
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Node

@export 
var Ball: PackedScene
var label
signal _custom_signal

func _ready():
	label = Label.new()
	label.text = "0"
	add_child(label)
			
func _input(event):
	if event.is_action_pressed("click"):
		var new_ball = Ball.instantiate()
		new_ball.position = get_viewport().get_mouse_position()
		add_child(new_ball)
		

func _on_child_entered_tree(node):
	if label:
		if node != label:
			label.text = str(int(label.text) + 1)
			
		if int(label.text) % 5 == 0 and int(label.text):
			_custom_signal.emit()


# Which type of message system are the signals in Godot?

# In Godot, signals follow the publish-subscribe message system.
# This system allows objects to send messages (signals) to multiple listerners
# (subscribers) without needing to know which objects are receiving the messages.
# In Godot, objects (usually nodes) can emit signals that other nodes can connect to. 
# The connected nodes contain callback functions that are executed as soon as the signal
# is emitted.



# How to realize broadcasting with the message system in Godot?

# To realize broadcasting in Godot, you could create a
# central publisher node that acts as a hub for the broadcasting message.
# This central node will emit a signal whenever there is a message to broadcast.
# Any node that wants to receive this message can connect to the central node.
# If by broadcasting it is meant that each node should be able to receive a 
# message without having to be subscribed to a publisher, this cannot be 
# realized in Godot using signals.


