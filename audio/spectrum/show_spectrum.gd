extends Node2D

const VU_COUNT = 16
const FREQ_MAX = 11050.0

const WIDTH = 400
const HEIGHT = 100

const MIN_DB = 60

var spectrum

func _draw():
	#warning-ignore:integer_division
	
	
	var w = WIDTH / VU_COUNT
	var prev_hz = 0
	for i in range(1, VU_COUNT+1):
		var hz = i * FREQ_MAX / VU_COUNT;
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT
		draw_rect(Rect2(w * i, HEIGHT - height, w, height), Color.white)
		prev_hz = hz


func _process(_delta):
	update()


func _ready():
	spectrum = AudioServer.get_bus_effect_instance(0,0)
	var label_node = get_node("Label")
	var audio_device_list = AudioServer.capture_get_device_list()
	for i in range(0, audio_device_list.size()):
		label_node.text = label_node.text + " " + audio_device_list[i]
	#if 1 == 1: # No microphone detected
	#	label_node.text = "I can't hear you..."
	#else: # Mic is plugged in
	#	label_node.text = "I'm listening...'"
