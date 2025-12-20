extends Control

# ---SIGNAL DEFINITIONS------------------------------------------

# The script can perform these two elements
# Other scripts like main.gd can subscribe/react to them
signal host_game_pressed(name_text)
signal join_game_pressed(address_text, name_text)

# ---VARIABLES----------------------------------------------

# @onready only initializes if the node finished loading
# (var: void *) variable that points to an object in this case
# $: find this child in the scene-tree, must be same path as in scene dock
@onready var Address_Input = $CenterContainer/VBoxContainer/AddressInput
@onready var Name_Input = $CenterContainer/VBoxContainer/NameInput

# ---FUNCTIONS----------------------------------------------

# func: like a void function
# _on_...: signaled functions via Node-Dock
# host function
func _on_host_button_pressed():
	if Name_Input.text == "":
		Name_Input.text = "HostPlayer"

	# emit_signal: calls all functions that wait for this signal
	host_game_pressed.emit(Name_Input.text)

# join function
func _on_join_button_pressed():
	if Name_Input.text == "":
		Name_Input.text = "GuestPlayer"

	# pass two arguments (IP and Name)
	join_game_pressed.emit(Address_Input.text, Name_Input.text)
