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
#	var titleSizeX = 0.3 * 720
#	var titleSizeY = 0.1 * 1080
#
#	$Title.rect_size = Vector2(titleSizeX ,titleSizeY)
#	$Title/TitleText.rect_size = Vector2(titleSizeX,titleSizeY)
#
#
#	$Score.rect_position = Vector2(432,0)
#	$Score.rect_size = Vector2(288,54)
#	$Score/ScoreText.rect_size = Vector2(288,54)
#
#	$HighScore.rect_position = Vector2(432,54)
#	$HighScore.rect_size = Vector2(288,54)
#	$HighScore/HighScoreText.rect_size = Vector2(288,54)
#
#	$Retry.rect_position = Vector2(201,0)
#	$Retry.rect_size = Vector2(57,40)
#
#	$MainMenu.rect_position = Vector2(201,40)
#	$MainMenu.rect_size = Vector2(57,40)
#
	$Message.rect_position = Vector2(72,129)
	$Message.rect_size = Vector2(576, 576)


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
