extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var score = 0
var highScore = 0

signal resetGame
signal MainMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	initializeUI()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Score/ScoreText.text = ("Score: " + str(score))
	$HighScore/HighScoreText.text = ("High Score: " + str(highScore))
	 

func initializeUI():
	#Ensure Game UI stays in first tenth of viewport.
	var getViewportDimensions = get_viewport().size
	$Title.rect_size = Vector2(getViewportDimensions.x * 0.3,getViewportDimensions.y * 0.1)
	$Title/TitleText.rect_size = Vector2(getViewportDimensions.x * 0.3,getViewportDimensions.y * 0.1)
	
	
	$Score.rect_position = Vector2(getViewportDimensions.x * 0.5,0)
	$Score.rect_size = Vector2(getViewportDimensions.x * 0.5,getViewportDimensions.y * 0.05)
	$Score/ScoreText.rect_size = Vector2(getViewportDimensions.x * 0.5,getViewportDimensions.y * 0.05)
	
	$HighScore.rect_position = Vector2(getViewportDimensions.x * 0.5,getViewportDimensions.y * 0.05)
	$HighScore.rect_size = Vector2(getViewportDimensions.x * 0.5,getViewportDimensions.y * 0.05)
	$HighScore/HighScoreText.rect_size = Vector2(getViewportDimensions.x * 0.5,getViewportDimensions.y * 0.05)
	
	$Retry.rect_position = Vector2(getViewportDimensions.x * 0.35,0)
	$Retry.rect_size = Vector2(getViewportDimensions.x * 0.1,getViewportDimensions.y * 0.05)
	
	$MainMenu.rect_position = Vector2(getViewportDimensions.x * 0.35,getViewportDimensions.y * 0.05)
	$MainMenu.rect_size = Vector2(getViewportDimensions.x * 0.1,getViewportDimensions.y * 0.05)
	
	$Message.rect_position = Vector2(getViewportDimensions.x *0.1,getViewportDimensions.y * 0.1)
	$Message.rect_size = Vector2(getViewportDimensions.x *0.8, getViewportDimensions.x * 0.8)


func _on_Retry_pressed():
	emit_signal("resetGame") 


func _on_MainMenu_pressed():
	emit_signal("MainMenu")


func _on_MuteAudio_pressed():
	#Toggle SFX Audio Bus
	var busIndex = AudioServer.get_bus_index("SFX")
	if AudioServer.is_bus_mute(busIndex):
		AudioServer.set_bus_mute(busIndex,false)
		$MuteAudio.text = "Sound Effects: On"
	else:
		AudioServer.set_bus_mute(busIndex,true)
		$MuteAudio.text = "Sound Effects: Off"


func _on_MuteMusic_pressed():
	#Toggle BGAudio Bus
	var busIndex = AudioServer.get_bus_index("BGAudio")
	if AudioServer.is_bus_mute(busIndex):
		AudioServer.set_bus_mute(busIndex,false)
		$MuteMusic.text = "Music: On"
	else:
		AudioServer.set_bus_mute(busIndex,true)
		$MuteMusic.text = "Music: Off"
