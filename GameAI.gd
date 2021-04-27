extends Node

enum {UP, RIGHT, DOWN, LEFT}

const DIR_MATRIX: Dictionary = {
	UP: Vector2(0,-1),
	RIGHT: Vector2(1,0),
	DOWN: Vector2(0,1),
	LEFT: Vector2(-1,0)
}

var game2048: Game2048

var numbers: Dictionary = {}
var colors: Dictionary = {}

var number_of_moves = 0

var layer_data: Array = [192, 64, 64, 4]
var test_input: Array = [1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0]

var ai_array: Array

var gen_target = 50
var gen_size = 16
var gen = 0

var start_time
var end_time

var fit_array: Array = []


func _ready() -> void:
	print("GameAI")
	start_time = OS.get_time()
	print(start_time)
	
	seed(0)
	
	game2048 = Game2048.new()
	game2048.add_random_tile()
	set_up_board()
	update_board(game2048)
	
	
	$Timer.start()
	
	set_up_ai(gen_size)

func _process(delta):
	reset_ai()
	if gen < gen_target:
		if (gen + 1) % 5 == 0:
			print("------------ GEN {0} -----------".format([gen + 1]))
			run_ai(true)
		else:
			run_ai(false)
		gen += 1
	else:
		end_time = OS.get_time()
		print("Hours: ", end_time.hour - start_time.hour, "   Minutes: ", end_time.minute - start_time.minute, "   Seconds: ", end_time.second - start_time.second)
		
		var strings: PoolStringArray = []
		for avg in fit_array:
			strings.append(avg)
		
		var file = File.new()
		file.open("user://save_game.csv", File.WRITE)
		file.store_csv_line(strings)
		file.close()
		
		get_tree().quit()

func set_up_ai(num: int):
	for i in range(num):
		var ai = AI.new("AI {0}".format([i]), layer_data)
		ai_array.append(ai)

func run_ai(prt: bool = false):
	for ai in ai_array:
		while !ai.done:
			ai.update()
	
	ai_array.sort_custom(FitnessSorterAI, "sort")
	
	var model_array: Array = []
	
	for i in range(gen_size):
		if i <= gen_size / 2:
			model_array.append(ai_array[i].copy_model())
		else:
			ai_array[i].model = model_array.pop_front()
			ai_array[i].model.mutate(32)
	
	var avg_fitness = 0
	var best_fit = 0
	var best
	
	for ai in ai_array:
		avg_fitness += ai.fitness
		if prt:
			print("[{0}] Fitness: {1}".format([ai.name, ai.fitness]))
		if ai.fitness > best_fit:
			best = ai
	update_board(best.game2048)
	
	avg_fitness /= gen_size
	
	fit_array.append(avg_fitness)


func reset_ai():
	for ai in ai_array:
		ai.reset_game()


func update_board(data: Game2048):
	for x in range(4):
		for y in range(4):
			var pos = Vector2(x,y)
			set_tile(pos, data.get_value(pos))


func set_up_board():
	numbers[Vector2(0,0)] = $CanvasLayer/UI/MarginContainer/GameBord/Num01
	numbers[Vector2(1,0)] = $CanvasLayer/UI/MarginContainer/GameBord/Num02
	numbers[Vector2(2,0)] = $CanvasLayer/UI/MarginContainer/GameBord/Num03
	numbers[Vector2(3,0)] = $CanvasLayer/UI/MarginContainer/GameBord/Num04
	numbers[Vector2(0,1)] = $CanvasLayer/UI/MarginContainer/GameBord/Num05
	numbers[Vector2(1,1)] = $CanvasLayer/UI/MarginContainer/GameBord/Num06
	numbers[Vector2(2,1)] = $CanvasLayer/UI/MarginContainer/GameBord/Num07
	numbers[Vector2(3,1)] = $CanvasLayer/UI/MarginContainer/GameBord/Num08
	numbers[Vector2(0,2)] = $CanvasLayer/UI/MarginContainer/GameBord/Num09
	numbers[Vector2(1,2)] = $CanvasLayer/UI/MarginContainer/GameBord/Num10
	numbers[Vector2(2,2)] = $CanvasLayer/UI/MarginContainer/GameBord/Num11
	numbers[Vector2(3,2)] = $CanvasLayer/UI/MarginContainer/GameBord/Num12
	numbers[Vector2(0,3)] = $CanvasLayer/UI/MarginContainer/GameBord/Num13
	numbers[Vector2(1,3)] = $CanvasLayer/UI/MarginContainer/GameBord/Num14
	numbers[Vector2(2,3)] = $CanvasLayer/UI/MarginContainer/GameBord/Num15
	numbers[Vector2(3,3)] = $CanvasLayer/UI/MarginContainer/GameBord/Num16
	
	colors[Vector2(0,0)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color01
	colors[Vector2(1,0)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color02
	colors[Vector2(2,0)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color03
	colors[Vector2(3,0)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color04
	colors[Vector2(0,1)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color05
	colors[Vector2(1,1)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color06
	colors[Vector2(2,1)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color07
	colors[Vector2(3,1)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color08
	colors[Vector2(0,2)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color09
	colors[Vector2(1,2)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color10
	colors[Vector2(2,2)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color11
	colors[Vector2(3,2)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color12
	colors[Vector2(0,3)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color13
	colors[Vector2(1,3)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color14
	colors[Vector2(2,3)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color15
	colors[Vector2(3,3)] = $CanvasLayer/UI/MarginContainer/ColorBord/Color16


func set_tile(pos: Vector2, num: int):
	numbers[pos].set_text(num as String if num != 0 else "")
	colors[pos].set_color(numbers[pos].get_colo())


class FitnessSorterAI:
	static func sort(a, b):
		if a.fitness > b.fitness:
			return true
		return false
