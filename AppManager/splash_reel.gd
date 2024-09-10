extends CanvasLayer

signal reel_finished

var current_splash_index: int = -1
var splash_units: Array[SplashUnit] = []
var current_tween: Tween

func _ready():
	for child in get_children():
		if child is SplashUnit:
			splash_units.append(child)
			child.hide()

func show_next_splash():
	if current_tween:
		current_tween.kill()

	current_splash_index += 1

	if current_splash_index >= splash_units.size():
		reel_finished.emit()
		return

	var splash = splash_units[current_splash_index]
	animate_splash(splash)

func animate_splash(splash: SplashUnit):
	splash.show()
	splash.modulate.a = 0

	current_tween = create_tween()
	current_tween.tween_property(splash, "modulate:a", 1.0, splash.fade_in_time)
	current_tween.tween_interval(splash.sustain_time)
	current_tween.tween_property(splash, "modulate:a", 0.0, splash.fade_out_time)
	current_tween.tween_callback(splash.hide)
	current_tween.tween_callback(show_next_splash)

func start_reel():
	current_splash_index = -1
	show_next_splash()

func skip_current_splash():
	if current_tween:
		current_tween.kill()
	
	if current_splash_index < splash_units.size():
		splash_units[current_splash_index].hide()

	show_next_splash()

func skip_all():
	if current_tween:
		current_tween.kill()
	
	for splash in splash_units:
		splash.hide()
	
	reel_finished.emit()

func reset():
	if current_tween:
		current_tween.kill()
	
	for splash in splash_units:
		splash.hide()
		splash.modulate.a = 1.0
	
	current_splash_index = -1
