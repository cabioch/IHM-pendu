extends Container


#TODO Stocker les Boutons qqpart pour pouvoir les match a un event
var buttons : Array
var keyCodes = [
	KEY_A, KEY_B, KEY_C, KEY_D, KEY_E, KEY_F, KEY_G, KEY_H, KEY_I, KEY_J, KEY_K,
	 KEY_L, KEY_M, KEY_N, KEY_O, KEY_P, KEY_Q, KEY_R, KEY_S, KEY_T, KEY_U,
	 KEY_V, KEY_W, KEY_X, KEY_Y, KEY_Z
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 26:
		var button: Button = load("res://LettreButton.tscn").instantiate()
		buttons.append(button)
		button.text = char(65 + i)
		button.pressed.connect(_on_button_pressed.bind(button))
		add_child(button)

func _input(event : InputEvent):
	# On vérifie que c'est bien une touche de clavier
	if !(event is InputEventKey) || !(event.is_pressed()):
		return
	var keycodeIndex = keyCodes.find(event.keycode)
	# Puis on vérifie que c'est bien une touche de clavier, jamais utilisée
	if keycodeIndex == -1 || buttons[keycodeIndex].disabled:
		return
	
	if buttons[keycodeIndex].disabled:
		return
	_on_button_pressed(buttons[keycodeIndex])
	


func _on_button_pressed(button: Button):
	$"../TopBoxContainer".guess_letter(button.text)
	button.disabled = true

func resetClavier():
	for item in get_children():
		item.disabled = false
