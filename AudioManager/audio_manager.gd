extends Node

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var intended_track: String = ""
var current_track: String = ""
const POOL_SIZE: int = 10
const SFX_COOLDOWN: float = 0.05
const FADE_DURATION: float = 5.0
var sfx_cooldowns: Dictionary = {}
var fade_tween: Tween

signal bass_current_value(value: float)
signal mid_current_value(value: float)
signal high_current_value(value: float)

const MUSIC_TRACKS = {
	"giorgio": {
		"loop": "res://AudioManager/giorgio_loop.mp3",
		"intro": "res://AudioManager/giorgio_intro.mp3" # optional
	},
	"gorgo": {
		"loop": "res://AudioManager/giorgio_loop.mp3",
	}
}

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
		if current_track:
			music_player.stream = load(MUSIC_TRACKS[current_track]["loop"])
			music_player.play()
	)

func play_music(track_name: String):
	if intended_track == track_name: return
	if not MUSIC_TRACKS.has(track_name):
		push_error("Track name not found: " + track_name)
		return
	
	intended_track = track_name
	
	if music_player.is_playing():
		_fade_out_music()
	else:
		_start_new_track(track_name)

func _fade_out_music():
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()
	
	if not music_player.is_playing() or music_player.volume_db <= linear_to_db(0.0):
		_on_fade_complete()
		return
	
	fade_tween = create_tween()
	fade_tween.set_trans(Tween.TRANS_LINEAR)
	fade_tween.set_ease(Tween.EASE_IN)
	var initial_volume = db_to_linear(music_player.volume_db)
	
	fade_tween.tween_method(
		func(value: float): 
			music_player.volume_db = linear_to_db(value),
		initial_volume,
		0.0,
		FADE_DURATION
	)

	fade_tween.finished.connect(_on_fade_complete, CONNECT_ONE_SHOT)

func _on_fade_complete():
	music_player.stop()
	music_player.volume_db = 0
	if intended_track != "":
		_start_new_track(intended_track)
	else:
		current_track = ""

func _start_new_track(track_name: String):
	current_track = track_name
	var track_data = MUSIC_TRACKS[track_name]
	
	if track_data.has("intro"):
		music_player.stream = load(track_data["intro"])
	else:
		music_player.stream = load(track_data["loop"])
	
	music_player.play()

func stop_music():
	intended_track = ""
	_fade_out_music()

func play_sound(sfx_path: String):
	if sfx_path in sfx_cooldowns:
		var time_since_last_play = Time.get_ticks_msec() - sfx_cooldowns[sfx_path]
		if time_since_last_play < SFX_COOLDOWN * 1000:
			return
	
	for sfx_player in sfx_players:
		if not sfx_player.is_playing():
			sfx_player.stream = load(sfx_path)
			sfx_player.play()
			sfx_cooldowns[sfx_path] = Time.get_ticks_msec()
			return
