extends Node

const AUTHORS := [
	"Matthew Murphy",
	"Anthony Yuen",
	"Megh Parikh",
]


func _ready():
	randomize()
	AUTHORS.shuffle()
	for author in AUTHORS:
		var label := Label.new()
		label.text = author
		label.align = Label.ALIGN_CENTER
		label.add_color_override("font_color", Color.black)
		label.add_font_override("font", preload("res://assets/fonts/big_font.tres"))
		$VBoxContainer.add_child(label)
