class_name MusicAnalyzer extends Node

@export var is_operating: bool = true
var frequency_ranges = {
	"bass": [80, 100],
	"mid": [100, 4000],
	"high": [4000, 20000]
}

var spectrum: AudioEffectSpectrumAnalyzerInstance
var bus_index: int

func _ready():
	bus_index = AudioServer.get_bus_index("Music")
	if bus_index != -1:
		spectrum = AudioServer.get_bus_effect_instance(bus_index, 0)
	else:
		push_warning("Music bus not found!")

func _process(_delta):
	if not is_operating: return
	if not spectrum: return

	var bass_magnitude = _get_magnitude_range(frequency_ranges["bass"][0], frequency_ranges["bass"][1])
	var mid_magnitude = _get_magnitude_range(frequency_ranges["mid"][0], frequency_ranges["mid"][1])
	var high_magnitude = _get_magnitude_range(frequency_ranges["high"][0], frequency_ranges["high"][1])
	
	AudioManager.bass_current_value.emit(bass_magnitude)
	AudioManager.mid_current_value.emit(mid_magnitude)
	AudioManager.high_current_value.emit(high_magnitude)

func _get_magnitude_range(from_freq: float, to_freq: float) -> float:
	var magnitude: float = 0.0
	var freq_count: int = 0
	
	for i in range(0, 100):
		var freq = lerp(from_freq, to_freq, float(i) / 100.0)
		magnitude += spectrum.get_magnitude_for_frequency_range(freq, freq).length()
		freq_count += 1
	
	return magnitude / freq_count if freq_count > 0 else 0.0
