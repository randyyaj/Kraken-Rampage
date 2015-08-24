
extends StaticBody2D

var bunk_count

func _ready():
	bunk_count = 0
	pass

func add_bunked():
	bunk_count+=1;
	get_node("Label").set_text("Bunked: " + str(bunk_count))
