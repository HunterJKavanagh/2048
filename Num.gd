extends CenterContainer

const DEFAULT_COLOR = Color(.125, .5, 1, .10)

var has_combined = false

func set_text(text: String):
	$Label.text = text

func get_text() -> String:
	return $Label.text

func is_empty() -> bool:
	return true if $Label.text == "" else false 

func get_colo() -> Color:
	var color: Color = Color(.125, .5, 1, .10)
	
	if $Label.text == "":
		color = Color(.125, .5, 1, .10)
		return color
	
	match $Label.text as int:
		2:
			color = Color(.125, .5, 1, .20)
		4:
			color = Color(.125, .5, 1, .28)
		8:
			color = Color(.125, .5, 1, .36)
		16:
			color = Color(.125, .5, 1, .44)
		32:
			color = Color(.125, .5, 1, .52)
		64:
			color = Color(.125, .5, 1, .60)
		128:
			color = Color(.125, .5, 1, .68)
		256:
			color = Color(.125, .5, 1, .76)
		512:
			color = Color(.125, .5, 1, .84)
		1024:
			color = Color(.125, .5, 1, .90)
		2048:
			color = Color(.125, .5, 1, 1)
	return color
