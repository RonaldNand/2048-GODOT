extends Node2D

var value = 2
var length = 256
var borderThickness = 0.04

func _ready():
	#Create a CELL based on specified length, scale border and font size accordingly.
	var borderLength = int(length * borderThickness)
	$Background.rect_size = Vector2(length,length)
	$Number.rect_size = Vector2(length,length)
	$Number.get("custom_fonts/font").set_size(length * 0.3)
	$LeftBorder.rect_size = Vector2(borderLength,length)
	$RightBorder.rect_position = Vector2(length-borderLength,0)
	$RightBorder.rect_size = Vector2(borderLength,length)
	$TopBorder.rect_size = Vector2(length,borderLength)
	$BottomBorder.rect_position = Vector2(0,length -borderLength)
	$BottomBorder.rect_size = Vector2(length,borderLength)


func _process(delta):
	#Display VALUE in cell.
	if (value != 0 && value != null):
		$Number.text = str(value)
	else:
		$Number.text = ""

