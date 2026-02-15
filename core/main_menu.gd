extends CanvasLayer

@export var start : TextureButton

func _ready() -> void:
	start.button_down.connect(func(): _on_start_button_down(start.get_node("AnimationPlayer")))

#func _on_button_start_button_down() -> void:
	#animation_player.play("press_button")
	#await animation_player.animation_finished
	#SceneManager.change_to("res://core/main.tscn")
#
#
#func _on_button_start_mouse_entered() -> void:
	#animated_sprite_2d.play("holder")
#
#
#func _on_button_start_mouse_exited() -> void:
	#animated_sprite_2d.play("normal")
#
#
#func _on_texture_button_button_down() -> void:
	#animation_player.play("press_button")
	#await animation_player.animation_finished
	#SceneManager.change_to("res://core/main.tscn")


#func _on_start_pressed(texture_button: TextureButton) -> void:
	#var animation_player = texture_button.get_node("AnimationPlayer")
	#animation_player.play("press_button")
	#await animation_player.animation_finished
	#SceneManager.change_to("res://core/main.tscn")


func _on_start_button_down(animation:AnimationPlayer) -> void:
	animation.play("button_press")
	await animation.animation_finished
	SceneManager.change_to("res://core/main.tscn")
