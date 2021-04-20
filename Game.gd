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

var layer_data: Array = [16, 16, 16, 4]
var test_input: Array = [1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0]

var ai_array: Array

var average_moves = 0
var avg_move_array: Array = []

var gen_target = 5000
var gen = 0


func _ready() -> void:
	seed(0)
	
	game2048 = Game2048.new()
	game2048.add_random_tile()
	set_up_board()
	update_board(game2048)
	
	
	$Timer.start()
	
	set_up_ai(32)

func _process(delta):
	if gen < gen_target:
		run_block(50,32)
	else:
		print(avg_move_array)
		get_tree().quit()
	

func run_block(gen_num: int, ai_num: int):
	average_moves = 0
	for i in range(gen_num):
		if i == gen_num - 1:
			print("------------ GEN {0} -----------".format([gen + 1]))
			average_moves = average_moves / (gen_num)
			run_ai(true)
		else:
			run_ai(false)
		reset_ai()
		gen += 1

func set_up_ai(num: int):
	for i in range(num):
		var ai = AI.new("AI {0}".format([i]), layer_data)
		ai_array.append(ai)

func run_ai(prt: bool):
	
	for ai in ai_array:
		while !ai.done:
			ai.update()
			update_board(ai.game2048)
	
	var min_ai: AI = ai_array[0]
	var max_ai: AI = ai_array[0]
	
	for ai in ai_array:
		if ai.moves > max_ai.moves:
			max_ai = ai
		if ai.moves < min_ai.moves:
			min_ai = ai
	
	for ai in ai_array:
		if ai == max_ai:
			continue
		if ai == min_ai:
			min_ai.model.load_weights(max_ai.model.weights.duplicate())
			continue
		ai.model.mutate("rand")
	
	if prt:
		print("AVG MAX: ", average_moves)
		avg_move_array.append(average_moves)
	
	print("[{0}]: {1}".format([max_ai.name, max_ai.moves]))
	average_moves += max_ai.moves


func _on_Timer_timeout():
	pass
#	if !ai_one.done:
#		ai_one.update()
#		update_board(ai_one.game2048)
#	else:
#		$Timer.stop()
#
#		print("\n[{0}]".format([ai_one.name]))
#		print("MOVES: ", ai_one.moves)
#		print("WON: ", !ai_one.lost)


func reset_ai():
	for ai in ai_array:
		ai.reset_game()


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_W or event.scancode == KEY_UP:
			print("UP")
			game2048.shift_board(UP)
			update_board(game2048)
		if event.scancode == KEY_D or event.scancode == KEY_RIGHT:
			print("RIGHT")
			game2048.shift_board(RIGHT)
			update_board(game2048)
		if event.scancode == KEY_S or event.scancode == KEY_DOWN:
			print("DOWN")
			game2048.shift_board(DOWN)
			update_board(game2048)
		if event.scancode == KEY_A or event.scancode == KEY_LEFT:
			print("LEFT")
			game2048.shift_board(LEFT)
			update_board(game2048)


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
