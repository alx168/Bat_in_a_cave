class_name Prey
extends CharacterBody2D

@onready var anim = $Sprite2D

func _ready() -> void:
	anim.play("float")

func _physics_process(delta: float) -> void:
	# maybe have this thing move around
	pass
