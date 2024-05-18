extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var main_scene = get_tree().get_root().get_node("/root/Main")
	main_scene.connect("_custom_signal", _on_custom_func)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_custom_func():
	for child in get_children():
		if child is Sprite2D or CollisionShape2D:
			child.scale /= 2
