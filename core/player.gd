extends Node
class_name Player

var life: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func take_damage(dmg:int):
	life -= dmg
