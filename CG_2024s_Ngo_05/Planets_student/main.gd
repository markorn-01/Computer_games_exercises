# Name:        Quang Minh, Ngo;      student no.: 4742554
# Coauthor:    Taha Beytullah Erkoc; student no.: 4740805
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Node

var earth_orbit_radius = 20
var moon_orbit_radius = 5
var orbit_speed = 0.1
var Earth
var Moon
var position = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Ground.set_visible(false)
	
	# Create Earth object as a child of Sun
	Earth = RigidBody3D.new()
	$Sun.add_child(Earth)
	
	var ECSGMesh3D = CSGMesh3D.new()
	ECSGMesh3D.scale = Vector3(2, 2, 2)
	
	# Set mesh properties
	
	# 1. Set mesh as sphere with radius = 1
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = 1
	ECSGMesh3D.mesh = sphere_mesh
	
	# 2. Set the color to blue
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0, 0, 1) # Blue color
	ECSGMesh3D.material = material
	Earth.add_child(ECSGMesh3D)
	
	# Set Collision shape preoperties
	var ECollisionShape3D = CollisionShape3D.new()
	ECollisionShape3D.shape = SphereShape3D.new()
	ECollisionShape3D.scale = Vector3(2, 2, 2)
	Earth.add_child(ECollisionShape3D)
	
	# Create Moon object as a child of Earth
	Moon = RigidBody3D.new()
	Earth.add_child(Moon)
	
	var MCSGMesh3D = CSGMesh3D.new()
	MCSGMesh3D.scale = Vector3(1, 1, 1)
	
	# Set mesh properties
	
	# 1. Set mesh as sphere with radius = 1
	var m_sphere_mesh = SphereMesh.new()
	m_sphere_mesh.radius = 1
	MCSGMesh3D.mesh = m_sphere_mesh
	
	# 2. Set the color to blue
	var m_material = StandardMaterial3D.new()
	m_material.albedo_color = Color(1, 1, 0) # Blue color
	MCSGMesh3D.material = m_material
	Moon.add_child(MCSGMesh3D)
	
	# Set Collision shape preoperties
	var MCollisionShape3D = CollisionShape3D.new()
	MCollisionShape3D.shape = SphereShape3D.new()
	MCollisionShape3D.scale = Vector3(1, 1, 1)
	Moon.add_child(MCollisionShape3D)
	
	# Set the initial position of Earth and Moon
	update_earth_orbit_position(0)
	update_moon_orbit_position(0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += delta * orbit_speed
	# Update the position of Earth and Moon based on time
	update_earth_orbit_position(position)
	update_moon_orbit_position(position * 20)

func update_earth_orbit_position(angle):
	# Calculate the new position of Earth on the orbit
	var x = earth_orbit_radius * cos(angle)
	var z = earth_orbit_radius * sin(angle)
	
	# Set the position of Earth relative to the Sun
	Earth.transform.origin = Vector3(x, 0, z)
	
func update_moon_orbit_position(angle):
	# Calculate the new position of Moon on the orbit
	var x = moon_orbit_radius * cos(angle)
	var z = moon_orbit_radius * sin(angle)
	
	# Set the position of Moon relative to the Earth
	Moon.transform.origin = Vector3(x, 0, z)

# How are the objects organized in this game?
# We have 3 objects: Sun, Earth, and Moon, where the Sun acts as a central body.
# The Earth is the child of the Sun and Moon is the child of the Earth. 
# Each Earth and Moon orbits around their central bodies (parent nodes).
# and includes a CSGMesh3D which represents its visual appearance
# as well as a CollisionShape3D which represents the collision shape.

# How is the global motion of the "Moon" realized in this game?
# Every time frame, in the _process() function, 
# the position of the Moon is calculated by delta times the orbit speed times 20
# (since the orbital speed of the moon is 20 times faster than the earth).
# Also, update_moon_orbit_position() is triggered in the _process() function, 
# which is used to calculate the new position of the Moon on the orbit based on
# the angle. 
