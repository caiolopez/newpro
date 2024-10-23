extends Node

var music_player: AudioStreamPlayer
var sfx_players = [AudioStreamPlayer]
var current_intro_track: String = ""
var current_loop_track: String = ""
const POOL_SIZE: int = 10

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"
	
	for i in POOL_SIZE:
		var sfx_player = AudioStreamPlayer.new()
		add_child(sfx_player)
		sfx_player.bus = "SFX"
		sfx_players.append(sfx_player)
	
	music_player.finished.connect(func():
		if current_loop_track:
			music_player.stream = load(current_loop_track)
			music_player.play()
			)
		

func play_music(loop_path: String, intro_path: String = ""):
	if current_loop_track == loop_path: return
	
	current_loop_track = loop_path
	music_player.stream = load(loop_path)
	music_player.play()

func play_sound(path: String):
	for sfx_player in sfx_players:
		if not sfx_player.playing:
			sfx_player.stream = load(path)
			sfx_player.play()
			return

func stop_music():
	music_player.stop()
	current_intro_track = ""
	current_loop_track = ""

#MusicManager.play_music("res://music/level1.mp3")
