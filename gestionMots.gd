extends Node
const CHEMIN_DICT = "res://mots.txt"
var mot_choisi: String = ""
var compteurErreur: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	mon_init()

func mon_init():
	$MotRechercher.text = ""
	mot_choisi = select_random_word(CHEMIN_DICT).to_upper()
	$Pendu.texture = load("res://assets/penduTiles/tile.png")
	
	print("Mot choisi : ", mot_choisi)
	for i in mot_choisi.length():
		$MotRechercher.text += "_"

func select_random_word(fichierMots):
	
	var f = FileAccess.open(fichierMots, FileAccess.READ)
	var tab = f.get_as_text().split("\n", false)
	f.close()
	var indiceMot = randi_range(0, len(tab))
	# Bug bizzare, ça nous rajoute un espace à la fin → On l'enlève
	return tab[indiceMot].strip_edges()
	
func guess_letter(letter: String):
	letter = letter[0]
	if !mot_choisi.contains(letter):
		if erreur():
			finPartie(false)
		return
	var newWord = $MotRechercher.text
	for i in range(len(mot_choisi)):
		if mot_choisi[i] == letter:
			newWord[i] = letter
	$MotRechercher.text = newWord
	if newWord == mot_choisi:
		finPartie(true)
	
		
func finPartie(gagne: bool):
	await blink(gagne)
	$"../LettersHFlowContainer".resetClavier()
	compteurErreur = 0
	mon_init()
	
func blink(gagne : bool, blinkDelay: float = 0.5):
	var baseText = $MotRechercher.text if gagne else mot_choisi
	var color: Color = Color.GREEN if gagne else Color.RED
	var text: String = "Gagné :)" if gagne else "Perdu :("
	
	for i in range(2):
		$MotRechercher.text = text
		$MotRechercher.add_theme_color_override("font_color", color)
		await get_tree().create_timer(blinkDelay).timeout
		$MotRechercher.text = baseText
		$MotRechercher.remove_theme_color_override("font_color")
		await get_tree().create_timer(blinkDelay).timeout

# Retourne true si la partie est perdue :(
# A Appeler quand il y a une mauvaise lettre
func erreur():
	var path = "res://assets/penduTiles/tile00"+str(compteurErreur)+".png"
	$Pendu.texture = load(path)
	compteurErreur += 1
	if compteurErreur >= 10:
		return true
