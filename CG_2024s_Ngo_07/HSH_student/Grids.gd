extends Panel

var default_font = ThemeDB.fallback_font
var default_font_size = ThemeDB.fallback_font_size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()

func _draw():
	# Your draw commands here
	draw_line(Vector2(0, 180), Vector2(600, 180), Color.WHITE, 1.0)
	
	for n in range(12):
		draw_line(Vector2(n * 50, 180 - 5), Vector2(n * 50, 180 + 5), Color.WHITE, 1.0)
		draw_string(default_font, Vector2(n * 50, 180 + 30), \
			str(n), HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)
