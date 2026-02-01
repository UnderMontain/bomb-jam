extends Node
class_name MusicManager

@export var tracks: Array[AudioStream] 
var player: AudioStreamPlayer
var current_track := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)
	player.finished.connect(_on_track_finished)
	if tracks.size() > 0:
		play_current()

func play_current():
	player.stream = tracks[current_track]
	player.play()
	
func _on_track_finished():
	current_track = (current_track +1) % tracks.size()
	play_current()
