# Name:     Taha Beytullah Erkoc; student no.: 4740805
# Coauthor: Quang Minh, Ngo;      student no.: 4742554
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Button

var label_point_a
var label_point_b
var label_final
var ball
var button
var right_paddle
var left_paddle
# Called when the node enters the scene tree for the first time.
func _ready():
	label_point_a = get_node("../Panel/LabelpointA")
	label_point_b = get_node("../Panel/LabelpointB")
	label_final = get_node("../Panel/Labelfinal")
	ball = get_node("../Ball")
	right_paddle = get_node("../Right")
	left_paddle = get_node("../Left")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	ball.reset()
	label_point_a.text = '0'
	label_point_b.text = '0'
	label_final.text = ''
	right_paddle.reset()
	left_paddle.reset()
	
	
