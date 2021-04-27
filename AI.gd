class_name AI
extends Node

const states: Dictionary = {
	0: 0,
	2: 1,
	4: 2,
	8: 3,
	16: 4,
	32: 5,
	64: 6,
	128: 7,
	256: 8,
	512: 9,
	1024: 10,
	2048: 11,
}

var game2048: Game2048
var model: NeuralNetwork

var done: bool = false
var lost: bool = false
var fitness: float = 0
var moves: int = 0


func _init(name: String, layer_data: Array):
	self.name = name
	
	game2048 = Game2048.new()
	
	model = NeuralNetwork.new(layer_data, NeuralNetwork.get_rand_weights(layer_data))


func copy_model() -> NeuralNetwork:
	return NeuralNetwork.new(model.layer_data, model.weights.duplicate(true))


func reset_game():
	done = false
	lost = false
	fitness = 0
	moves = 0
	game2048.setup()

func update():
	if !done:
		_update()
		self.fitness = game2048.get_score()
	else:
		print("not done")


func get_input() -> Array:
	var input_array: Array = []
	
	for x in range(4):
		for y in range(4):
			for i in range(12):
				var input: int = 0
				if i == states[game2048.get_value(Vector2(x,y))]:
					input = 1
				input_array.append(input)
	
	return input_array


func _update():
	var output = model.update(get_input())
	
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
