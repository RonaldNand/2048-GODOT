extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bgImageDict = {
	1: "res://Art/BGImage/PexelsBG1.jpg",
	2: "res://Art/BGImage/PexelsBG2.jpg",
	3: "res://Art/BGImage/PexelsBG3.jpg",
	4: "res://Art/BGImage/PexelsBG4.jpg",
	5: "res://Art/BGImage/PexelsBG5.jpg"
}

var audioDict = {
	1: "res://Art/BGAudio/AurorabyLukeBergs.mp3",
	2: "res://Art/BGAudio/BetOnItSilent%20Partner.mp3",
	3: "res://Art/BGAudio/ChillVibesbyPufino.mp3",
	4: "res://Art/BGAudio/MorningRainbyLukrembo.mp3",
	5: "res://Art/BGAudio/TropicsbyScandinavianz.mp3"
}

var lastTrack

# Called when the node enters the scene tree for the first time.
func _ready():
	setBGImage()
	setBGAudio()
	
func setBGImage():
	#Pick Random BG Image from Dict, scale it and set it as Background's Texture
	var BGImage = bgImageDict[(randi() % bgImageDict.size() + 1)]
	$Background.set_texture(load(BGImage)) 
	var BGImageSize = Vector2(578,800)
	var textureSize = $Background.texture.get_size()
	var factor = BGImageSize/textureSize
	$Background.scale = factor

func setBGAudio():
	#Pick a random audio track from Dict, play it.
	var track = audioDict[(randi() % audioDict.size() + 1)]
	$BGAudio.set_stream(load(track))
	$BGAudio.play()
	
func _on_BGAudio_finished():
	setBGAudio() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

