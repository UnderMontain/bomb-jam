extends Node2D
class_name Enemy

@onready var label: Label = $Label
var life: int = 2

signal died(cell_pos: Vector2i)

func _ready() -> void:
	label.text = str(life)

func take_damage(cell_pos: Vector2i,dmg: int):
	life -= dmg
	label.text = str(life)
	if life <= 0:
		died.emit(cell_pos)
		var tween = get_tree().create_tween()
		tween.tween_property($AnimatedSprite2D, "modulate", Color.RED, 1.0)
		await tween.tween_property($AnimatedSprite2D, "scale", Vector2(), 1.0).finished
		queue_free()
	

func init_life(life_init:int):
	life = life_init
	label.text = str(life)

func attack(player: Player):
	player.take_damage(1)
