class_name NeuralNetwork

var network: Array = []
var weights: Array = []

var layer_data: Array = []


func _init(layer_data: Array, weights: Array):
	self.layer_data = layer_data
	self.weights = weights
	
	setup_network()


func setup_network():
	network.clear()
	var tmp_weights: Array = weights.duplicate()
	for l in range(layer_data.size()):
		for n in range(layer_data[l]):
			if l == 0:
				var empty: Array = []
				network.push_back(Neuron.new(empty, 0))
			else:
				var neuron_weights: Array = []
				for i in range(layer_data[l - 1]):
					neuron_weights.push_back(tmp_weights.pop_front())
				network.push_back(Neuron.new(neuron_weights, 0))


func update(input_array: Array) -> Array:
	var output_values: Array = []
	
	var counter = -1
	
	for l in range(layer_data.size()):
		if l == 0:
			for n in range(layer_data[l]):
				counter = counter + 1
				network[counter].set_value(input_array[counter])
		else:
			var neuron_input_array: PoolRealArray
			var tmp_counter = counter - layer_data[l - 1]
			
			for i in range(layer_data[l -1]):
				neuron_input_array.push_back(network[tmp_counter + i].value)
			
			for n in range(layer_data[l]):
				counter = counter + 1
				network[counter].activate(neuron_input_array)
	
	counter = counter - layer_data[-1]
	for n in range(layer_data[-1]):
		output_values.append(network[counter + n].value)
	
	if output_values.size() == 0:
		pass
	
	return output_values


func mutate(number: int, type = "mod"):
	for n in range(number):
		var i: int = floor(rand_range(0, weights.size()))
		if type == "mod":
			weights[i] = weights[i] + (rand_range(-1, 1) / 5)
		elif type == "rand":
			weights[i] = rand_range(-1, 1)
	
	load_weights(self.weights)


func load_weights(new_weights: Array):
	self.weights = new_weights
	
	var tmp_network: Array = []
	var tmp_weights: Array = self.weights.duplicate()
	for l in range(layer_data.size()):
		for n in range(layer_data[l]):
			if l != 0:
				tmp_network.push_back(network.pop_front())
			else:
				var neuron_weights: Array = []
				for i in range(layer_data[l - 1]):
					neuron_weights.push_back(tmp_weights.pop_front())
				
				var tmp_neuron = network.pop_front()
				tmp_neuron.input_weights = neuron_weights
				tmp_network.push_back(tmp_neuron)
	if network.size() == 0:
		network = tmp_network
	else:
		pass


static func get_rand_weights(layer_data: PoolIntArray) -> Array:
	var number_of_weights: int
	var rand_weights: Array = []
	for l in range(layer_data.size()):
		if l != 0:
			number_of_weights = number_of_weights + (layer_data[l - 1] * layer_data[l])
	for i in range(number_of_weights):
		rand_weights.push_back(rand_range(-1, 1))
	
	return rand_weights
