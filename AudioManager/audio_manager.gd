extends Node

var music_player: AudioStreamPlayer
var sfx_players: Array[SFXPlayer] = []
var positional_sfx_players: Dictionary = {}
var intended_track_name: StringName = ""
var current_track_name: StringName = ""
const POOL_SIZE: int = 100
const SFX_COOLDOWN: float = 0.05
const FADE_DURATION: float = 2.0
var sfx_cooldowns: Dictionary = {}
var fade_tween: Tween
@onready var hooks: Node = $SfxHooks
@onready var audio_banks: AudioBanks = $AudioBanks

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
		"loop": "res://AudioManager/Music/test1.mp3",
		},
	"test2": {
		"loop": "res://AudioManager/Music/test2.mp3",
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
		var sfx_player: SFXPlayer = SFXPlayer.new()
		add_child(sfx_player)
		sfx_player.bus = "SFX"
		sfx_players.append(sfx_player)

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
		for source_object in positional_sfx_players.keys():
			var player = positional_sfx_players[source_object]
			var distance = camera_pos.distance_to(player.global_position)

			if player.playing:
				if distance > player.max_distance:
					player.stop()
					player.stream = null
			else:
				if distance < (player.max_distance / 1.1) and source_object is AudioEmiter and source_object.currently_active:
					var sfx_data: SFXData = audio_banks.get_sfx_data(source_object.sfx_name)
					player.stream = sfx_data.pick_sound()
					player.play()

func _on_game_paused():
	if music_player.playing:
		music_player.set_stream_paused(true)
	for sfx_player in sfx_players:
		if sfx_player.playing && sfx_player.pausable:
			sfx_player.set_stream_paused(true)
	for player in positional_sfx_players.values():
		player.process_mode = Node.PROCESS_MODE_DISABLED

func _on_game_unpaused():
	if music_player.stream:
		music_player.set_stream_paused(false)
	for sfx_player in sfx_players:
		if sfx_player.stream && sfx_player.pausable:
			sfx_player.set_stream_paused(false)
	for player in positional_sfx_players.values():
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

func play_sfx(sfx_name: StringName, volume_adjustment: float = 0.0):
	if _is_sfx_in_cooldown(sfx_name):
			return

	for sfx_player in sfx_players:
		if not sfx_player.is_playing():
			var sfx_data: SFXData = audio_banks.get_sfx_data(sfx_name)
			if !sfx_data:
				return null
			sfx_player.sfx_name = sfx_name
			sfx_player.pausable = sfx_data.pausable
			sfx_player.stream = sfx_data.pick_sound()
			sfx_player.pitch_scale = sfx_data.pick_pitch_scale()
			sfx_player.volume_db = volume_adjustment
			sfx_player.play()
			sfx_cooldowns[sfx_name] = Time.get_ticks_msec()
			return

func stop_sfx(sfx_name: StringName):
	for sfx_player in sfx_players:
		if sfx_player.is_playing() and sfx_player.sfx_name == sfx_name:
			sfx_player.stop()

func _is_sfx_in_cooldown(sfx_name: StringName) -> bool:
	if sfx_name in sfx_cooldowns:
		var time_since_last_play = Time.get_ticks_msec() - sfx_cooldowns[sfx_name]
		if time_since_last_play < SFX_COOLDOWN * 1000:
			return true
	return false

func play_positional_sfx(sfx_name: StringName, position: Vector2, source_object: Node, max_distance: float = 10000.0, volume_adjustment: float = 0.0) -> SFXPlayer2D:
	var sfx_data: SFXData = audio_banks.get_sfx_data(sfx_name)
	if !sfx_data:
		print_debug("Error: No " + sfx_name + "found in AudioBanks")
		return

	if source_object in positional_sfx_players:
		var existing_player: SFXPlayer2D = positional_sfx_players[source_object]
		existing_player.sfx_name = sfx_name
		existing_player.pausable = sfx_data.pausable
		existing_player.stream = sfx_data.pick_sound()
		existing_player.pitch_scale = sfx_data.pick_pitch_scale()
		existing_player.global_position = position
		existing_player.max_distance = max_distance
		existing_player.play()
		return existing_player

	var new_player: SFXPlayer2D = SFXPlayer2D.new()
	add_child(new_player)
	new_player.bus = "SFX"
	new_player.process_mode = Node.PROCESS_MODE_PAUSABLE
	new_player.sfx_name = sfx_name
	new_player.pausable = sfx_data.pausable
	new_player.stream = sfx_data.pick_sound()
	new_player.pitch_scale = sfx_data.pick_pitch_scale()
	new_player.volume_db = volume_adjustment
	new_player.global_position = position
	new_player.max_distance = max_distance
	new_player.attenuation = 1.0
	new_player.panning_strength = 1.0
	new_player.play()
	
	positional_sfx_players[source_object] = new_player
	new_player.finished.connect(func(): _on_positional_sfx_finished(source_object))
	return new_player

func _on_positional_sfx_finished(source_object: Node):
	if source_object in positional_sfx_players:
		var player = positional_sfx_players[source_object]
		player.queue_free()
		positional_sfx_players.erase(source_object)

func update_positional_sfx_position(source_object: Node, position: Vector2):
	if source_object in positional_sfx_players:
		positional_sfx_players[source_object].global_position = position

func update_positional_sfx_pitch(source_object: Node, pitch: float):
	if source_object in positional_sfx_players:
		positional_sfx_players[source_object].pitch_scale = pitch

func stop_specific_positional_sfx(source_object: Node):
	if source_object in positional_sfx_players:
		var player = positional_sfx_players[source_object]
		player.stop()
		player.queue_free()
		positional_sfx_players.erase(source_object)

func stop_all_positional_sfx():
	for player: SFXPlayer2D in positional_sfx_players.values():
		player.stop()
		player.queue_free()
	positional_sfx_players.clear()
