class_name Neuron

var number_of_inputs: int = 0
var bias: int = 0

var value: float = 0

var input_weights: Array = []

func _init(input_weights: Array, bias: int):
	if input_weights.size() > 0:
		self.input_weights = input_weights
		number_of_inputs = self.input_weights.size()
	
	self.bias = bias
	
	return self

func activate(input_array: Array) -> void:
	if input_array.size() == number_of_inputs:
		var tmp_array: Array = []
		tmp_array.resize(number_of_inputs)
		
		for i in range(0, number_of_inputs):
			tmp_array[i] = input_array[i] * input_weights[i]
		
		var tmp: float = 0
		for i in tmp_array:
			tmp = tmp + i
		
		value = activation_function(tmp + bias)
	else:
		print_debug("ERROR: intput_array.size() != nuber_of_inputs")
	

func activation_function(input: float) -> float:
	return 1 /( 1 + exp(-input))

func set_value(new_value: float) -> void:
	self.value = new_value
