extends CanvasLayer

@export var start : TextureButton
@export var exit: TextureButton

func _ready() -> void:
	start.button_down.connect(func(): _on_start_button_down(start.get_node("AnimationPlayer")))
	exit.button_down.connect(func(): _on_exit_button_down(start.get_node("AnimationPlayer")))
	
func _on_start_button_down(animation:AnimationPlayer) -> void:
	animation.play("button_press")
	await animation.animation_finished
	SceneManager.change_to("res://core/main.tscn")

func _on_exit_button_down(animation:AnimationPlayer) -> void:
	animation.play("button_press")
	await animation.animation_finished
	get_tree().quit()
