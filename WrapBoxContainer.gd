extends BoxContainer

# Peut être a changer, suivant le sprite du pendu
func _on_resized():
	if size.x > size.y:
		$TopBoxContainer.vertical = false
	else:
		$TopBoxContainer.vertical = true
