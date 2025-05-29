extends Node2D

@onready var scale_pic = Vector2 (0.8,0.8)
@onready var anzeige = $Instructions/Anzeige
@onready var beschreibung = $Instructions/Beschreibung

var manual = preload("res://interactivemanual.tscn")

var attributes_dict = {}
var number_of_instructions
var page =1
# Called when the node enters the scene tree for the first time.

func _ready():
	var parser = XMLParser.new()
	parser.open("res://assets/"+Globals.instruction_shown +".xml")
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			attributes_dict = {}
			number_of_instructions = parser.get_attribute_count()
			for idx in range(number_of_instructions):
				attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			#print("The ", node_name, " element has the following attributes: ", attributes_dict)
	#Ersten Anleitungsteil auslesen
	$Beschreibung.clear()
	var message = attributes_dict["0"]
	$Titel.bbcode_text = "%s" % message
	$Beschreibung.append_text (attributes_dict[str(page)])
	$Anzeige.set_texture(load("res://Bilder/"+attributes_dict["0"]+"/1.png"))
	$Anzeige.scale =scale_pic

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	page+=1
	if page < number_of_instructions:
		$Beschreibung.clear()
		$Beschreibung.append_text(attributes_dict[str(page)])
		$Anzeige.set_texture(load("res://Bilder/"+attributes_dict["0"]+"/" +str(page) +".png"))
		$Anzeige.scale =scale_pic
	if page == number_of_instructions:
		$Button.set_text("Zurück")
	if page > number_of_instructions:
		self.queue_free()
		var group = get_tree().get_first_node_in_group("start")
		group.visible=true
