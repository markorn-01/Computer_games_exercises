# Name:     Taha Beytullah Erkoc; student no.: 4740805
# Coauthor: Quang Minh, Ngo;      student no.: 4742554
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Area2D

var label_point_a
var label_point_b
var label_final

func _ready():
	label_point_a = get_node("../Panel/LabelpointA")
	label_point_b = get_node("../Panel/LabelpointB")
	label_final = get_node("../Panel/Labelfinal")
	
func _on_wall_area_entered(area):
	#print(area)
	if area.name == "Ball":
		
		if name == "RightWall":
			label_point_a.text = str(int(label_point_a.text) + 1)
		else:
			label_point_b.text = str(int(label_point_b.text) + 1)
		
		if label_point_a.text == '3':
			label_final.text = "THE WINNER IS PLAYER A."
		if label_point_b.text == '3':
			label_final.text = "THE WINNER IS PLAYER B."
		
		#oops, ball went out of game place, reset
		area.reset()
