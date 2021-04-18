extends Node

var numbers: Dictionary = {}
var colors: Dictionary = {}

enum {UP, RIGHT, DOWN, LEFT}

const DIR_MATRIX: Dictionary = {
	UP: Vector2(0,-1),
	RIGHT: Vector2(1,0),
	DOWN: Vector2(0,1),
	LEFT: Vector2(-1,0)
}


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_W or event.scancode == KEY_UP:
			print("UP")
			shift_board(UP)
			
			add_random_tile()
		if event.scancode == KEY_D or event.scancode == KEY_RIGHT:
			print("RIGHT")
			shift_board(RIGHT)
			
			add_random_tile()
		if event.scancode == KEY_S or event.scancode == KEY_DOWN:
			print("DOWN")
			shift_board(DOWN)
			
			add_random_tile()
		if event.scancode == KEY_A or event.scancode == KEY_LEFT:
			print("LEFT")
			shift_board(LEFT)
			
			add_random_tile()


func _ready() -> void:
	set_up_board()
	
	add_random_tile()


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


func shift_board(dir: int) -> void:
	match dir:
		UP:
			for y in range(1, 4):
				for x in range(4):
					var m1 = shift(Vector2(x,y), UP)
					var m2 = shift(Vector2(x,y) + DIR_MATRIX[UP], UP) if m1 == true and y > 1 else false
					var m3 = shift(Vector2(x,y) + DIR_MATRIX[UP] * 2, UP) if m2 == true and y > 2 else false
		RIGHT:
			for x in range(2,-1, -1):
				for y in range(4):
					var m1 = shift(Vector2(x,y), RIGHT)
					var m2 = shift(Vector2(x,y) + DIR_MATRIX[RIGHT], RIGHT) if m1 == true and x < 2 else false
					var m3 = shift(Vector2(x,y) + DIR_MATRIX[RIGHT] * 2, RIGHT) if m2 == true and x < 1 else false
		DOWN:
			for y in range(2,-1, -1):
				for x in range(4):
					var m1 = shift(Vector2(x,y), DOWN)
					var m2 = shift(Vector2(x,y) + DIR_MATRIX[DOWN], DOWN) if m1 == true and y < 2 else false
					var m3 = shift(Vector2(x,y) + DIR_MATRIX[DOWN] * 2, DOWN) if m2 == true and y < 1 else false
		LEFT:
			for x in range(1,4):
				for y in range(4):
					var m1 = shift(Vector2(x,y), LEFT)
					var m2 = shift(Vector2(x,y) + DIR_MATRIX[LEFT], LEFT) if m1 == true and x > 1 else false
					var m3 = shift(Vector2(x,y) + DIR_MATRIX[LEFT] * 2, LEFT) if m2 == true and x > 2 else false
	
	for x in range(4):
		for y in range(4):
			numbers[Vector2(x,y)].has_combined = false


func shift(pos: Vector2, dir: int) -> bool:
	var start_pos: Vector2 = pos
	var dir_pos: Vector2 = start_pos + DIR_MATRIX[dir]
	
	if numbers[dir_pos].is_empty():
		numbers[dir_pos].set_text(numbers[start_pos].get_text())
		numbers[start_pos].set_text("")
		
		colors[start_pos].set_color(numbers[start_pos].get_colo())
		colors[dir_pos].set_color(numbers[dir_pos].get_colo())
	elif numbers[dir_pos].get_text() == numbers[start_pos].get_text() and !numbers[dir_pos].has_combined and !numbers[start_pos].has_combined:
		numbers[dir_pos].set_text( ((numbers[start_pos].get_text() as int) + 
				(numbers[Vector2(dir_pos)].get_text() as int)) as String )
		numbers[start_pos].set_text("")
		
		colors[start_pos].set_color(numbers[start_pos].get_colo())
		colors[dir_pos].set_color(numbers[dir_pos].get_colo())
		
		numbers[dir_pos].has_combined = true
	else: 
		return false
	return true

func add_random_tile():
	var done: bool = false
	var count: int = 0
	
	while !done:
		var random_vec2 = Vector2(floor(rand_range(0, 4)), floor(rand_range(0, 4)))
		if numbers[random_vec2].is_empty():
			print(random_vec2)
			done = true
			
			if randf() > 0.9:
				numbers[random_vec2].set_text("4")
				colors[random_vec2].set_color(numbers[random_vec2].get_colo())
			else:
				numbers[random_vec2].set_text("2")
				colors[random_vec2].set_color(numbers[random_vec2].get_colo())
		else:
			count += 1
			if count > 100:
				print("No Room!")
				done = true


func set_tile(pos: Vector2, num: int):
	numbers[pos].set_text(num as String)
	colors[pos].set_color(numbers[pos].get_colo())
