extends Node

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var positional_sfx_players: Array[AudioStreamPlayer2D] = []
var active_positional_sfx: Dictionary = {}
var intended_track_name: StringName = ""
var current_track_name: StringName = ""
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
	"main_menu": {
		"loop": "res://AudioManager/bizarre.mp3",
		},
	"gorgo": {
		"loop": "res://AudioManager/giorgio_loop.mp3",
		}
}

const SFX = {
	"snare": {
		"resource": preload("res://AudioManager/snare.mp3"),
		"pausable": false
		},
	"white_noise_loop": {
		"resource": preload("res://AudioEmiter/white_noise.ogg"),
		"pausable": true
		}
}

func _ready():
	AppManager.game_paused.connect(_on_game_paused)
	AppManager.game_unpaused.connect(_on_game_unpaused)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"

	for i in POOL_SIZE:
		var sfx_player = AudioStreamPlayer.new()
		add_child(sfx_player)
		sfx_player.bus = "SFX"
		sfx_players.append(sfx_player)

	for i in POOL_SIZE:
		var positional_sfx_player = AudioStreamPlayer2D.new()
		add_child(positional_sfx_player)
		positional_sfx_player.bus = "SFX"
		positional_sfx_player.process_mode = Node.PROCESS_MODE_PAUSABLE
		positional_sfx_players.append(positional_sfx_player)

	music_player.finished.connect(func():
		if current_track_name:
			music_player.stream = load(MUSIC_TRACKS[current_track_name]["loop"])
			music_player.play()
	)

func _process(_delta):
	_process_audio_distances()

func _process_audio_distances():
	if AppManager.camera:
		var camera_pos = AppManager.camera.global_position
		for source_object in active_positional_sfx.keys():
			var player = active_positional_sfx[source_object]
			var distance = camera_pos.distance_to(player.global_position)

			if player.playing:
				if distance > player.max_distance:
					player.stop()
					player.stream = null
			else:
				if distance < (player.max_distance / 1.1) and source_object is AudioEmiter and source_object.currently_active:
					player.stream = SFX[source_object.sfx_name]["resource"]
					player.play()

func _on_game_paused():
	if music_player.playing:
		music_player.set_stream_paused(true)
	for sfx_player in sfx_players:
		if sfx_player.playing:
			for sfx_name in SFX:
				if sfx_player.stream == SFX[sfx_name]["resource"] and SFX[sfx_name]["pausable"]:
					sfx_player.set_stream_paused(true)
	for player in active_positional_sfx.values():
		player.process_mode = Node.PROCESS_MODE_DISABLED

func _on_game_unpaused():
	if music_player.stream:
		music_player.set_stream_paused(false)
	for sfx_player in sfx_players:
		if sfx_player.stream:
			for sfx_name in SFX:
				if sfx_player.stream == SFX[sfx_name]["resource"] and SFX[sfx_name]["pausable"]:
					sfx_player.set_stream_paused(false)
	for player in active_positional_sfx.values():
		player.process_mode = Node.PROCESS_MODE_PAUSABLE

func play_music(track_name: StringName, should_save: bool = true):
	if intended_track_name == track_name: return
	if not MUSIC_TRACKS.has(track_name):
		push_error("Track name not found: " + track_name)
		return
	
	intended_track_name = track_name
	if should_save:
		SaveManager.log_hero_change("current_music", intended_track_name)
	
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
	if intended_track_name != "":
		_start_new_track(intended_track_name)
	else:
		current_track_name = ""

func _start_new_track(track_name: String):
	current_track_name = track_name
	var track_data = MUSIC_TRACKS[track_name]
	
	if track_data.has("intro"):
		music_player.stream = load(track_data["intro"])
	else:
		music_player.stream = load(track_data["loop"])
	
	music_player.play()

func stop_music():
	intended_track_name = ""
	_fade_out_music()

func stop_music_immediately():
	intended_track_name = ""
	music_player.stop()
	music_player.volume_db = 0
	current_track_name = ""
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()

func play_sfx(sfx_name: StringName):
	if _is_sfx_in_cooldown(sfx_name):
			return
	
	for sfx_player in sfx_players:
		if not sfx_player.is_playing():
			sfx_player.stream = SFX[sfx_name]["resource"]
			sfx_player.play()
			sfx_cooldowns[sfx_name] = Time.get_ticks_msec()
			return

func stop_sfx(sfx_name: StringName):
	for sfx_player in sfx_players:
		if sfx_player.is_playing() and sfx_player.stream == SFX[sfx_name]:
			sfx_player.stop()

func _is_sfx_in_cooldown(sfx_name: StringName) -> bool:
	if sfx_name in sfx_cooldowns:
		var time_since_last_play = Time.get_ticks_msec() - sfx_cooldowns[sfx_name]
		if time_since_last_play < SFX_COOLDOWN * 1000:
			return true
	return false

func play_positional_sfx(sfx_name: StringName, position: Vector2, source_object: Node, max_distance: float = 10000.0) -> AudioStreamPlayer2D:
	if source_object in active_positional_sfx:
		var player = active_positional_sfx[source_object]
		player.stream = SFX[sfx_name]["resource"]
		player.global_position = position
		player.max_distance = max_distance
		player.play()
		return player

	for player in positional_sfx_players:
		if not player.is_playing():
			player.stream = SFX[sfx_name]["resource"]
			player.global_position = position
			player.max_distance = max_distance
			player.attenuation = 1.0
			player.panning_strength = 1.0
			player.play()
			
			active_positional_sfx[source_object] = player
			player.finished.connect(func(): _on_positional_sfx_finished(source_object))
			return player
	return null

func _on_positional_sfx_finished(source_object: Node):
	if source_object in active_positional_sfx:
		active_positional_sfx.erase(source_object)

func update_positional_sfx_position(source_object: Node, position: Vector2):
	if source_object in active_positional_sfx:
		active_positional_sfx[source_object].global_position = position

func stop_specific_positional_sfx(source_object: Node):
	if source_object in active_positional_sfx:
		active_positional_sfx[source_object].stop()
		active_positional_sfx[source_object].stream = null
		active_positional_sfx.erase(source_object)

func stop_all_positional_sfx():
	for player in active_positional_sfx.values():
		player.stop()
		player.stream = null
	active_positional_sfx.clear()
