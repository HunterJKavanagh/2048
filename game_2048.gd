class_name Game2048
extends Node

enum {UP, RIGHT, DOWN, LEFT}

const DIR_MATRIX: Dictionary = {
	UP: Vector2(0,-1),
	RIGHT: Vector2(1,0),
	DOWN: Vector2(0,1),
	LEFT: Vector2(-1,0)
}

const SCORE_CHART: Dictionary = {
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

var tiles: Array = []
var number_of_moves = 0


func _init():
	setup()


func setup():
	number_of_moves = 0
	tiles.clear()
	for x in range(4):
		tiles.append([])
		for _y in range(4):
			tiles[x].append(Tile.new())
	add_random_tile()

func get_value(pos: Vector2) -> int:
	return tiles[pos.x][pos.y].value
func set_value(pos: Vector2, value: int):
	tiles[pos.x][pos.y].value = value


func get_score(weighted: bool = false) -> float:
	var score = 0
	var largest_value = 0
	
	for x in range(4):
		for y in range(4):
			var value = tiles[x][y].value
			score += value
			if value > largest_value:
				largest_value = value
	
	if weighted:
		return (score/100) * SCORE_CHART[largest_value]
	else:
		return score


func shift_board(dir: int) -> bool:
	var moved = false
	match dir:
		UP:
			for y in range(1, 4):
				for x in range(4):
					var m1 = shift(Vector2(x,y), UP)
					var m2 = shift(Vector2(x,y) + DIR_MATRIX[UP], UP) if m1 == true and y > 1 else false
					shift(Vector2(x,y) + DIR_MATRIX[UP] * 2, UP) if m2 == true and y > 2 else false
					if m1:
						moved = true
		RIGHT:
			for x in range(2,-1, -1):
				for y in range(4):
					var m1 = shift(Vector2(x,y), RIGHT)
					var m2 = shift(Vector2(x,y) + DIR_MATRIX[RIGHT], RIGHT) if m1 == true and x < 2 else false
					shift(Vector2(x,y) + DIR_MATRIX[RIGHT] * 2, RIGHT) if m2 == true and x < 1 else false
					if m1:
						moved = true
		DOWN:
			for y in range(2,-1, -1):
				for x in range(4):
					var m1 = shift(Vector2(x,y), DOWN)
					var m2 = shift(Vector2(x,y) + DIR_MATRIX[DOWN], DOWN) if m1 == true and y < 2 else false
					shift(Vector2(x,y) + DIR_MATRIX[DOWN] * 2, DOWN) if m2 == true and y < 1 else false
					if m1:
						moved = true
		LEFT:
			for x in range(1,4):
				for y in range(4):
					var m1 = shift(Vector2(x,y), LEFT)
					var m2 = shift(Vector2(x,y) + DIR_MATRIX[LEFT], LEFT) if m1 == true and x > 1 else false
					shift(Vector2(x,y) + DIR_MATRIX[LEFT] * 2, LEFT) if m2 == true and x > 2 else false
					if m1:
						moved = true
	
	for x in range(4):
		for y in range(4):
			tiles[x][y].has_combined = false
	
	if moved:
		add_random_tile()
		number_of_moves += 1
	
	return moved

func shift(pos: Vector2, dir: int) -> bool:
	var start_pos: Vector2 = pos
	var dir_pos: Vector2 = start_pos + DIR_MATRIX[dir]
	
	if get_value(dir_pos) == 0:
		set_value(dir_pos, get_value(start_pos))
		set_value(start_pos, 0)
	elif get_value(dir_pos) == get_value(start_pos) and !tiles[dir_pos.x][dir_pos.y].has_combined and !tiles[start_pos.x][start_pos.y].has_combined:
		set_value(dir_pos, get_value(start_pos) + get_value(dir_pos))
		set_value(start_pos, 0)
		tiles[dir_pos.x][dir_pos.y].has_combined = true
	else: 
		return false
	if get_value(dir_pos) == 2048:
		print("WINNER")
		print("WINNER")
		print("WINNER")
	return true

func add_random_tile():
	var done: bool = false
	var count: int = 0
	
	while !done:
		var random_vec2 = Vector2(floor(rand_range(0, 4)), floor(rand_range(0, 4)))
		if get_value(random_vec2) == 0:
			done = true
			
			if randf() > 0.9:
				set_value(random_vec2, 4)
			else:
				set_value(random_vec2, 2)
		else:
			count += 1
			if count > 100:
#				print("No Room!")
				done = true
