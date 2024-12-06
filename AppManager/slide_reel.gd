extends Control

signal reel_finished

var current_slide_index: int = -1
var slides: Array[Slide] = []
var current_tween: Tween

func _ready() -> void:
	for child in get_children():
		if child is Slide:
			slides.append(child)
			child.hide()

func show_next_slide():
	if current_tween:
		current_tween.kill()

	current_slide_index += 1

	if current_slide_index >= slides.size():
		reel_finished.emit()
		return

	var slide = slides[current_slide_index]
	animate_slide(slide)

func animate_slide(slide: Slide):
	slide.show()
	slide.modulate.a = 0

	current_tween = create_tween()
	current_tween.tween_property(slide, "modulate:a", 1.0, slide.fade_in_time)
	current_tween.tween_interval(slide.sustain_time)
	current_tween.tween_property(slide, "modulate:a", 0.0, slide.fade_out_time)
	current_tween.tween_callback(slide.hide)
	current_tween.tween_interval(slide.after_fadeout_time)
	current_tween.tween_callback(show_next_slide)

func start_reel():
	current_slide_index = -1
	show_next_slide()

func skip_current_slide():
	if current_tween:
		current_tween.kill()
	
	if current_slide_index < slides.size():
		slides[current_slide_index].hide()

	show_next_slide()

func skip_all():
	if current_tween:
		current_tween.kill()
	
	for slide in slides:
		slide.hide()
	
	reel_finished.emit()

func reset():
	if current_tween:
		current_tween.kill()
	
	for slide in slides:
		slide.hide()
		slide.modulate.a = 1.0
	
	current_slide_index = -1
