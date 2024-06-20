extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
@export var Outline: Color = Color.YELLOW
@export var Width: float = 2.0

func _draw():
	var poly = get_polygon()
	for i in range(1 , poly.size()):
		draw_line(poly[i-1] , poly[i], Outline , Width)
	draw_line(poly[poly.size() - 1] , poly[0], Outline , Width)
