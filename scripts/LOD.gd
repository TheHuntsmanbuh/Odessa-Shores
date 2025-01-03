extends Node3D
# gets references to itself
@onready var Model = $mesh
@onready var low = $low
@onready var card = $card

func update_player_position(playerpos):
	var modelpos = Model.global_position
	var distance = modelpos.distance_to(playerpos)
	
	#lowest detail so show the sprite only
	if distance > 200:
		Model.hide()
		low.hide()
		card.show()
	#middle detail so show the low detal model
	elif distance > 100:
		Model.hide()
		low.show()
		card.hide()
	#high detail
	else:
		Model.show()
		low.hide()
		card.hide()
