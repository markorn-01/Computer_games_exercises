# Name:        Quang Minh, Ngo;      student no.: 4742554
# Coauthor:    Taha Beytullah Erkoc; student no.: 4740805
# faculty:     Mathematics and Computer Science
# discipline:  Data and Computer Science

extends Node2D

# Reference paper:
#M. Eitz and G. Lixu, "\href{https://ieeexplore.ieee.org/document/4273369/}
#{Hierarchical Spatial Hashing for Real-time Collision Detection}," 
#\textit{IEEE International Conference on Shape Modeling and Applications 2007 (SMI '07)}, 
#Minneapolis, MN, USA, 2007, pp. 61-70, doi: 10.1109/SMI.2007.18.

func _on_edit_hash_text_submitted(_new_text):
	$"Edit Hash".text = str(abs(int($"Edit Hash".text)))


func _on_edit_point_text_submitted(_new_text):
	$"Edit Point".text = str(abs(float($"Edit Point".text)))


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
