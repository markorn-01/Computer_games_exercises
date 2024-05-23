extends Area2D

func _on_wall_area_entered(area):
	#print(area)
	if area.name == "Ball":
		#oops, ball went out of game place, reset
		area.reset()
