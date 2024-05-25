# Name:     Taha Beytullah Erkoc; student no.: 4740805
# Coauthor: Quang Minh, Ngo;      student no.: 4742554
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Area2D

@export var _bounce_direction = 1

func _on_area_entered(area):
	if area.name == "Ball":
		area.direction = (area.direction + Vector2(0, _bounce_direction)).normalized()
