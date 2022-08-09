extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var grid 
export (PackedScene) var button

# Called when the node enters the scene tree for the first time.
func _ready():
	$HowToPlayMessage.hide()
	gridSelect()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Quit_pressed():
	get_tree().quit() 

func _on_Play_pressed():
	$HowToPlayMessage.hide()
	togglePlay("show")


func _on_How_to_Play_pressed():
	togglePlay("hide")
	if $HowToPlayMessage.is_visible():
		$HowToPlayMessage.hide()
	else:
		$HowToPlayMessage.show() 
	


func play(length):
	var newGrid = grid.instance()
	newGrid.length = length
	get_parent().add_child(newGrid)
	hide()
	
func gridSelect():
	var viewportSize = get_viewport().size
	for x in 16:
		if x < 3:
			continue
		var newButton = button.instance()
		newButton.text = (str(x)+"x"+str(x)+" grid")
		newButton.rect_position = Vector2(0,0 + (x * 40))
		$Play.add_child(newButton)
	for x in $Play.get_child_count():
		var number
		if x < 7:
			number = int($Play.get_child(x).text[0])
		else: 
			number = (int($Play.get_child(x).text[0]) *10)+ int($Play.get_child(x).text[1])
		$Play.get_child(x).connect("pressed",self,"play",[number])
	togglePlay("hide")
		
func togglePlay(string):
	for x in $Play.get_child_count():
		match string:
			"show":
				$Play.get_child(x).show()
			"hide":
				$Play.get_child(x).hide()
			
		


