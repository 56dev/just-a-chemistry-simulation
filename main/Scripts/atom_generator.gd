extends Node

@export var path_to_periodic_table : StringName
@export var path_to_isotope_table : StringName
var periodic_table : Dictionary

##the periodic table above does not contain the different 
##abundances of isotopes, which necessitates this one.
var isotope_table : Dictionary

@onready var atomic_number_input = $AtomGeneratorUI/AtomNumberInput
@onready var atomic_number_input_ERROR_TEXT =  $AtomGeneratorUI/AtomNumberInput_ERRORTEXT
@onready var generation_options = $AtomGeneratorUI/GenerationOptions

func _ready():
	
	randomize()
	
	periodic_table = load_in_json_of_periodic_table()
	isotope_table = load_in_json_of_isotope_table()
	if periodic_table == {}:
		printerr("Failed to load JSON!")

func load_in_json_of_periodic_table() -> Dictionary:
	var file = FileAccess.open(path_to_periodic_table, FileAccess.ModeFlags.READ)
	
	if file:
		var json_string = file.get_as_text()
		file.close()

		var json_result = JSON.parse_string(json_string)

		if json_result:
			return json_result  # This will be a Dictionary or Array
	
	return {}

func load_in_json_of_isotope_table() -> Dictionary:
	var file = FileAccess.open(path_to_isotope_table, FileAccess.ModeFlags.READ)
	
	if file:
		var json_string = file.get_as_text()
		file.close()

		var json_result = JSON.parse_string(json_string)

		if json_result:
			return json_result  # This will be a Dictionary or Array
	
	return {}
	
	pass

func on_pressed():
	
	
	if !atomic_number_input.text.is_valid_int():
		atomic_number_input_ERROR_TEXT.set_visible(true)
		atomic_number_input_ERROR_TEXT.text = "Please enter a number!"
		return
	
	var atomic_number = int(atomic_number_input.text)
	
	
	#118 is the largest number where the elements are proven to exist and not hypothetical
	if atomic_number > 118:
		atomic_number_input_ERROR_TEXT.set_visible(true)
		atomic_number_input_ERROR_TEXT.text = "Please do not go above 118!"
		return
	
	#this is because the arrays start from zero, so you have to subtract one from the actual number.
	var element_index = atomic_number - 1
	
	atomic_number_input_ERROR_TEXT.set_visible(false)
	
	var result : String = periodic_table.elements[element_index].name 
	
	if generation_options.get_node("FollowIsotopicDistribution").button_pressed:
		var rng = RandomNumberGenerator.new()
		##TODO LATER/TOMORROW
		#var isotope_mass = 
	elif generation_options.get_node("AverageAtomicMass").button_pressed:
		var isotope_mass = roundi(float(periodic_table.elements[element_index].atomic_mass))
		
		result = result + ("-%s" % isotope_mass)
	
	print(result)
	
	pass
