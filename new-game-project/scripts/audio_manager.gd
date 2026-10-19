extends Node

# Add your sounds here: name -> stream
var sounds := {
	"cleaned": preload("res://Assets/Sounds/Trash Cleaned.wav"),
	"building": preload("uid://uxkpms1f3fgt")
}

func play_audio(sound_name: String, volume_db := 0.0, pitch := 1.0) -> void:
	if not sounds.has(sound_name):
		push_warning("AudioManager: no sound called '%s'" % sound_name)
		return
	var audio := AudioStreamPlayer.new()
	audio.stream = sounds[sound_name]
	audio.volume_db = volume_db
	audio.pitch_scale = pitch
	audio.finished.connect(audio.queue_free)
	add_child(audio)
	audio.play()
