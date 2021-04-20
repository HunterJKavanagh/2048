class_name AI
extends Node

var game2048: Game2048
var model: NeuralNetwork

var done: bool = false
var lost: bool = false
var moves: int = 0


func _init(name: String, layer_data: Array):
	self.name = name
	
	game2048 = Game2048.new()
	
	model = NeuralNetwork.new(layer_data, NeuralNetwork.get_rand_weights(layer_data))
	model.on = true


func reset_game():
	done = false
	lost = false
	moves = 0
	game2048.setup()

func update():
	if !done:
		_update()
	else:
		print("not done")

func _update():
	var inpute: Array = []
	
	for x in range(4):
		for y in range(4):
			if game2048.get_value(Vector2(x,y)) == 0:
				inpute.append(0)
			else:
				inpute.append(game2048.get_value(Vector2(x,y)) / 2048)
	
	var output = model.update(inpute)
	
	var i = 0
	while i < 4:
		if output.max() == -1:# or moves == 500:
#			print(moves)
			done = true
			lost = true
			break
		if output[i] == output.max():
			if game2048.shift_board(i):
				moves += 1
				break
			else:
				output[i] = -1
				i = 0
				continue
		i += 1

func _exit_tree():
	pass
