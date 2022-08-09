extends Node2D


export (PackedScene) var cell
export var length = 4
var numTable
var cells
var tableStates = []
var scores = []
 
var cellSize 

var score = 0
var highScore = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	startGame()
	highScore = loadHighScore()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	updateScore()
	
func startGame():
	randomize()
	$GameUI/Message.hide()
	tableStates = []
	position = setMeasurements()
	numTable = createTable(length)
	cells = createTable(length)
	populateTable()
	setNewNumber()
	copyGridState()
	get_tree().paused = false

func get_input():
	if (Input.is_action_just_pressed("move_up")):
		moveGrid("up")
	if (Input.is_action_just_pressed("move_down")):
		moveGrid("down")
	if (Input.is_action_just_pressed("move_left")):
		moveGrid("left")
	if (Input.is_action_just_pressed("move_right")):
		moveGrid("right")
	if (Input.is_action_just_pressed("undo")):
		restoreGridState()

func updateScore():
	$GameUI.score = score
	$GameUI.highScore = highScore

func resetGame():
	#Save Highscore if appropriate, recreate Grid.
	if (score > highScore):
		highScore = score
	score = 0
	saveHighScore()
	get_tree().paused = true
	startGame()

func setMeasurements():
	#Scale Table Positon of Cell Length so it ranges from 10% to 90% of Viewport
	#regardless of number of cells in table.
	var viewportSize = get_viewport().size
	var startX = viewportSize.x * 0.1
	var startY = viewportSize.y * 0.12
	var startingPosition = Vector2(startX,startY)
	cellSize = int ((viewportSize.x * 0.8) / length)
	return startingPosition
	

func createTable(length):
	#Create a square table of proportions length x length
	var table = []
	for x in length:
		table.append([])
		for y in length:
			table[x].append(0)
	return table

func populateTable():
	#Populate an instance of cell into each spot in table array.
	var row_offset = 0
	var col_offset = 0
	for x in length:
		col_offset = x * cellSize
		for y in length:
			row_offset = y * cellSize
			cells[x][y] = cell.instance()
			cells[x][y].length = cellSize
			cells[x][y].position += Vector2(row_offset, col_offset)
			add_child(cells[x][y])

func setNewNumber():
	#Play SFX for players previous move.
	if !$SFX.is_playing():
		$SFX.set_stream(load("res://Art/BGAudio/mixkit-interface-click-1126.mp3"))
		$SFX.play()
	#Determine which spots in numTable are free, then randomly choose two spots 
	#and spawn a number in each
	var freeSpots = []
	for x in range (0,length):
		for y in range (0,length):
			#Locate free spots in grid
			if (numTable[x][y] == 0):
				#Convert grid reference to number e.g [3][2] becomes 14
				var num = x * length + y  
				freeSpots.append(num)
	if (freeSpots.size() <= 0):
		#IF  no free spots are available determine if player still has moves and
		#either let them continue or end game.
		if matchPossible():
			return 0
		else:
			$GameUI/Message.show()
			$GameUI/Message.set_text("No More Moves!\n Try Again")
			$SFX.set_stream(load("res://Art/BGAudio/mixkit-video-game-mystery-alert-234.wav"))
			$SFX.play()
			yield(get_tree().create_timer(1.0),"timeout")
			get_tree().paused = true
			return 0
	var number1= randi() % freeSpots.size()
	var c1 = convertToCoordinate(freeSpots[number1])
	freeSpots.remove(number1)
	numTable[c1[0]][c1[1]] = 2
	#If only one free spot was available then skip second number.
	if (freeSpots.size() >= 1):
		var number2= randi() % freeSpots.size()
		var c2 = convertToCoordinate(freeSpots[number2])
		numTable[c2[0]][c2[1]] = 2
	setCells()

func convertToCoordinate(number):
	#Helper Method to quickly convert number to co-ordinate in table.
	var x = number/length 
	var y = number % length
	return [x,y]

func matchPossible():
	#Test each cell to see if cell's neighbour matches its value, conditionals will
	#ensure invalid index is not checked.
	for x in range (0,length):
		for y in range (0,length):
			if x > 0:
				if numTable[x][y] == numTable[x-1][y]:
					return true
			if x < length-1:
				if numTable[x][y] == numTable[x+1][y]:
					return true
			if y < length-1:
				if numTable[x][y] == numTable[x][y+1]:
					return true
			if y > 0:
				if numTable[x][y] == numTable[x][y-1]:
					return true
	return false

func setCells():
	#Set Cell Children Scene value to match number table.
	for x in range (0, length):
		for y in range (0,length):
			cells[x][y].value = numTable[x][y]
	
	

	
func copyGridState():
	var tableState = numTable.duplicate(true)
	tableStates.append(tableState)
	#debugPrintTable(tableStates[tableStates.size()-1])
	scores.append(score)
	

func restoreGridState():
	#Replaces numTable with previously saved version 
	if tableStates.size() > 0:
		print ("Undo")
		var state = tableStates[tableStates.size()- 1]
		tableStates.remove(tableStates.size()-1)
		numTable = state
		score = scores[scores.size()-1]
		scores.remove(scores.size()-1)
		setCells()
	else:
		print ("Cannot Undo!")

func moveGrid(direction):
	#If a square is blank (null value) ignore and move onto next square.
	#Rule 1: If the next square is blank move the square with value up until it merges or hits another square.
	#Rule 2: If a square merges, then stop moving it once 
	match direction:
		"up":
			for y in range (0,length):
				#Process cells by column
				for x in range (1,length):
					#Select cells, starting from 2ND ROW and moving downards
					while (x > 0):
						#IF cell ABOVE is blank move selected cell up
						if (numTable[x-1][y] == 0):
							numTable[x-1][y] = numTable[x][y]
							numTable[x][y] = 0
							#Increment x and attempt to move cell again on next
							#while loop pass.
							x -= 1
						#IF selected cell is blank, move onto next cell
						elif (numTable[x][y] == 0):
							break
						#IF cell ABOVE matches selected cell merge and move onto next cell
						elif (numTable[x-1][y] == numTable[x][y]):
							numTable[x-1][y] += numTable[x][y]
							numTable[x][y] = 0
							score += numTable[x-1][y]
							break 
						#IF cell cannot move or merge, move onto next cell
						else:
							break
			copyGridState()
			setNewNumber()
		"down":
			for y in range (0,length):
				#Process cells by COLUMN
				for x in range (length - 1 ,-1,-1):
					#Select cells, starting from 2ND LAST ROW and moving upwards
					while (x < length-1):
						#IF cell BELOW is blank move selected cell down
						if (numTable[x+1][y] == 0):
							numTable[x+1][y] = numTable[x][y]
							numTable[x][y] = 0
							x += 1
						#IF selected cell is blank, move onto next cell
						elif (numTable[x][y] == 0):
							break
						#IF cell BELOW matches selected cell merge and move onto next cell
						elif (numTable[x+1][y] == numTable[x][y]):
							numTable[x+1][y] += numTable[x][y]
							numTable[x][y] = 0
							score += numTable[x+1][y]
							break 
						#IF cell cannot move or merge, move onto next cell
						else:
							break
			copyGridState()
			setNewNumber()
		"left":
				for x in range (0,length):
					#Process cells by ROW
					for y in range (1,length):
						#Select cells, starting from 1ST COLUMN and moving rightward
						while (y > 0):
							#IF cell to the LEFT is blank move selected cell down
							if (numTable[x][y-1] == 0):
								numTable[x][y-1] = numTable[x][y]
								numTable[x][y] = 0
								y -= 1
							#IF selected cell is blank, move onto next cell
							elif (numTable[x][y] == 0):
								break
							#IF cell to the LEFT matches selected cell merge and move onto next cell
							elif (numTable[x][y-1] == numTable[x][y]):
								numTable[x][y-1] += numTable[x][y]
								numTable[x][y] = 0
								score += numTable[x][y-1]
								break 
							#IF cell cannot move or merge, move onto next cell
							else:
								break
				copyGridState()
				setNewNumber()
		"right":
			for x in range (0,length):
				#Process cells by ROW
				for y in range (length-1,-1,-1):
					#Select cells, starting from 2ND LAST COLUMN and moving leftward
					while (y < length - 1):
							#IF cell to the RIGHT is blank move selected cell down
							if (numTable[x][y+1] == 0):
								numTable[x][y+1] = numTable[x][y]
								numTable[x][y] = 0
								y += 1
							#IF selected cell is blank, move onto next cell
							elif (numTable[x][y] == 0):
								break
							#IF cell to the RIGHT matches selected cell merge and move onto next cell
							elif (numTable[x][y+1] == numTable[x][y]):
								numTable[x][y+1] += numTable[x][y]
								numTable[x][y] = 0
								score += numTable[x][y+1]
								break 
							#IF cell cannot move or merge, move onto next cell
							else:
								break
			copyGridState()
			setNewNumber()
			

func debugPrintTable (table):
	for x in length:
		print (table[x])
	print ("End Table")


func _on_GameUI_resetGame():
	resetGame()

func _on_GameUI_MainMenu():
	#Save HighScore if appropriate and load Main Menu
	if (score > highScore):
		highScore = score
	saveHighScore()
	get_tree().change_scene("res://Main.tscn")

func saveHighScore():
	#Open/Create File and write highScore value to it.
	var file = File.new()
	file.open("user://highscore.txt",File.WRITE)
	file.store_32(highScore)
	file.close()
	
func loadHighScore():
	#Open File and load highScore from it.
	var file = File.new()
	file.open("user://highscore.txt",File.READ)
	print (file.get_len())
	highScore = file.get_32()
	file.close()
	return highScore



