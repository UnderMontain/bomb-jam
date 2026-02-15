extends CanvasLayer

@export var fade_time := 0.3

var _next_scene_path := ""

var _is_changing := false

func change_to(path: String):
	if _is_changing:
		return
	
	_is_changing = true
	_next_scene_path = path
	get_tree().change_scene_to_file(_next_scene_path)
	_is_changing = false
