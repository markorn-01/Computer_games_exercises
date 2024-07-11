extends Control

#positions
var currentPos = Vector2()
var targetPos= Vector2()
#Jacobian
var J = Transform2D()
#pseudoinverse
var I = Transform2D()
#angles in Radians
var d1 = 10.0 * PI/ 180.0 
var d2 =  5.0 * PI/ 180.0 
var d3 =  0.0 * PI/ 180.0 
#bone length
const l1 = 80
const l2 = 70
const l3 = 50

func _process(delta):
	print("type of J", type_string(typeof(J)))
	print("J", J)
	if ( (currentPos- targetPos).length() > 1): _inverseKinematic(delta)

func _ready():
	#Put the window to the center
	var screen_size = DisplayServer.screen_get_size();
	var window_size = get_window().get_size();
	get_window().set_position(screen_size*0.5 - window_size*0.5);
	#Resize Window
	get_window().set_size(Vector2(500.0, 500.0));
	get_window().unresizable = not (false);
	
	#update position:
	currentPos.x = 250 + l1*cos(d1)+l2*cos(d1+d2)+l3*cos(d1+d2+d3)
	currentPos.y = 250 + l1*sin(d1)+l2*sin(d1+d2)+l3*sin(d1+d2+d3)

	#initialize target with current position:
	targetPos = currentPos
	
	#rotate nodes:
	get_node("J1").rotate(-d1);
	get_node("J1").get_node("B1").get_node("J2").rotate(-d2);
	get_node("J1").get_node("B1").get_node("J2").get_node("B2").get_node("J3").rotate(-d3);
	
	#print("current pos: ", currentPos)
	#print("node J4 pos:", get_node("J1").get_node("B1").get_node("J2").get_node("B2").get_node("J3").get_node("B3").get_node("J4").global_position)
	
	
	set_process_input(true)
	set_process(true)
	
func _inverseKinematic(delta):
	
	# compute error:
	var ex = targetPos.x - currentPos.x
	var ey = targetPos.y - currentPos.y
	
	# compute J:
	#TODO insert code here:
	J.x = Vector2(
		-l1 * sin(d1) - l2 * sin(d1 + d2) - l3 * sin(d1 + d2 + d3), 
		l1 * cos(d1) + l2 * cos(d1 + d2) + l3 * cos(d1 + d2 + d3)
	)
	J.y = Vector2(
		-l2 * sin(d1 + d2) - l3 * sin(d1 + d2 + d3), 
		l2 * cos(d1 + d2) + l3 * cos(d1 + d2 + d3)
	)
	J.origin = Vector2(
		-l3 * sin(d1 + d2 + d3), 
		l3 * cos(d1 + d2 + d3)
	)
	# Compute pseudoinverse J†:
	var JJT = Transform2D()
	JJT.x = ()
	
	print("JJT Type: ", J)
	# Inverse of (J * JT)
	var det = JJT.x.x * JJT.y.y - JJT.x.y * JJT.y.x
	var JJT_inv = Transform2D(
		Vector2(JJT.y.y / det, -JJT.x.y / det),
		Vector2(-JJT.y.x / det, JJT.x.x / det),
		Vector2()
	)
	var J_dagger = Transform2D(
		JT.x * JJT_inv.x.x + JT.y * JJT_inv.y.x,
		JT.x * JJT_inv.x.y + JT.y * JJT_inv.y.y,
		Vector2()
	)  # Pseudoinverse

	# Compute angle updates:
	var error = Vector2(ex, ey)
	var dTheta = Vector3(
		#J_dagger.x.dot(error), 
		#J_dagger.y.dot(error), 
		#J_dagger.origin.dot(error)
	) * 0.01  # Scaling factor 0.01
	
	# Update angles:
	d1 += dTheta.x
	d2 += dTheta.y
	d3 += dTheta.z
	
	# Update position:
	update_current_position()
	
	# Rotate nodes (Note: In Godot3 use negative angles!):
	update_node_rotation()
	
	# Hint: because of the matrix definition of Transform2D compute the transpose matrix of J here 
	# and switch the indices later
	# store (J * JT) and its inverse also in Transform2D. You only have to fill the neccessary entries.
	# Do not use the function Transform2D.affine_inverse() to compute the inverse of J or (J*JT)!
	# Compute the pseudoinverse of J instead.
	
	#compute angle updates:
	#TODO : insert code here
	
	#update angles:
	#TODO : insert code here
	
	#update position:
	#TODO : insert code here
	
	#rotate nodes (Note: In Godot3 use negative angles!):
	#TODO : insert code here

func update_current_position():
	currentPos.x = 250 + l1 * cos(d1) + l2 * cos(d1 + d2) + l3 * cos(d1 + d2 + d3)
	currentPos.y = 250 + l1 * sin(d1) + l2 * sin(d1 + d2) + l3 * sin(d1 + d2 + d3)

func update_node_rotation():
	get_node("J1").rotation = -d1
	get_node("J1").get_node("B1").get_node("J2").rotation = -d2
	get_node("J1").get_node("B1").get_node("J2").get_node("B2").get_node("J3").rotation = -d3

func _input(ev):
   # Mouse in viewport coordinates
	if ev is InputEventMouseButton:
		#print("Mouse Click at: ", ev.position)
		var temp= Vector2()
		temp[0] = 250 - ev.position[1] 
		temp[1] = ev.position[0] - 250 
		if (temp.length() < l1+l2+l3):
			targetPos.y = ev.position[0]
			targetPos.x = ev.position[1]
			#print("target pos: ", targetPos)
		else:
			print("Mouse click is outside our range ")
	
