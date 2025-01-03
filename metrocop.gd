extends CharacterBody3D

var speed = 2
var accel = 10

@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta: float) -> void:
	var direction = Vector3()
	
	
	
