extends Marker3D

var rotation_speed: float = 20.0  # degrees per second
var movement_speed: float = 3.0  # units per second

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Handle rotation
	if Input.is_action_pressed("Left"):
		rotate_y(deg_to_rad(rotation_speed * delta))
	elif Input.is_action_pressed("Right"):
		rotate_y(deg_to_rad(-rotation_speed * delta))

	# Handle vertical movement
	if Input.is_action_pressed("Up"):
		translate(Vector3(0, movement_speed * delta, 0))
	elif Input.is_action_pressed("Down"):
		translate(Vector3(0, -movement_speed * delta, 0))
