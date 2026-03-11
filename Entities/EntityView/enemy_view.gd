extends EntityView
class_name EnemyView

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var enemy_state = EnemyState

signal died(cell_pos: Vector2i)

#@onready var label: Label = $Label
var life: int = 2

func _setup(_enemy_state:EnemyState):
	enemy_state = _enemy_state
	animated_sprite_2d.sprite_frames = enemy_state.entity_data.sprite_frames
	animated_sprite_2d.play(&"idle")
	_enemy_state.died.connect(die_anim)

#func _ready() -> void:
#	label.text = str(life)


func die_anim():
	#life -= dmg
##	label.text = str(life)
	#if life <= 0:
	#died.emit(cell_pos)
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.RED, 1.0)
	await tween.tween_property($AnimatedSprite2D, "scale", Vector2(), 1.0).finished
	queue_free()

#func init_life(life_init:int):
#	life = life_init
#	label.text = str(life)
