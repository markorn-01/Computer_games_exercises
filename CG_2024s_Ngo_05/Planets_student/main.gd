extends Node

var orbit_radius = 20
var orbit_speed = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Ground.set_visible(false)
	
	# Create Earth object as a child of Sun
	var Earth = RigidBody3D.new()
	$Sun.add_child(Earth)
	
	var ECSGMesh3D = CSGMesh3D.new()
	ECSGMesh3D.scale = Vector3(2, 2, 2)
	# Create a new StandardMaterial3D
	var material = StandardMaterial3D.new()
	# Set the albedo color to blue
	material.albedo_color = Color(0, 0, 1) # Blue color
	# Apply the material to the CSGMesh3D
	ECSGMesh3D.material = material
	Earth.add_child(ECSGMesh3D)
	
	var ECollisionShape3D = CollisionShape3D.new()
	Earth.add_child(ECollisionShape3D)
	# Set the initial position of Earth
	update_orbit_position(Earth, 0)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update the position of Earth based on time
	update_orbit_position($Sun/Earth, delta * orbit_speed)

func update_orbit_position(Earth, time):
	# Calculate the new position of Earth on the orbit
	var angle = time  # You can modify this for different orbit patterns
	var x = orbit_radius * cos(angle)
	var z = orbit_radius * sin(angle)
	
	# Set the position of Earth relative to the Sun
	Earth.transform.origin = Vector3(x, 0, z)
