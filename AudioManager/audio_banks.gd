class_name AudioBanks
extends Node

@export var audio_banks: Dictionary[String, AudioBank]

# WIP ass function
func get_sfx_data(sfx_name: StringName) -> SFXData:
	if audio_banks["INTRO"].sfx_dictionary.has(sfx_name):
		return audio_banks["INTRO"].sfx_dictionary[sfx_name]
	else:
		return

func get_all_sfx_names() -> Array:
	var names: Array = []
	for bank: AudioBank in audio_banks.values():
		names.append_array(bank.sfx_dictionary.keys())

	return names
