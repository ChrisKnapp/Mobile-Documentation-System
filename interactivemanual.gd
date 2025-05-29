extends Node2D



@onready var v_box_container = $Startscreen/Control/VBoxContainer
@onready var title = $Startscreen/Control/Overview
@onready var logo = $Startscreen/Control/LogoRofa
@onready var description = $Startscreen/Control/Description
var instruction_set = preload("res://instruction.tscn")
var attributes_dict = {}
var button
# Called when the node enters the scene tree for the first time.
func _ready():
	title.expand_mode =1
	title.texture = load("res://Bilder/title.png")
	logo.texture =load("res://assets/logoROFA.png")
	var tween: Tween = create_tween()
	tween.tween_property(title, "modulate:a", 1.0, 1.0).from(0.0)
	
	#await tween.finished
	#tween.tween_property($Startscreen/Control/LogoRofa, "scale", Vector2(1.1,1.1), 1.0)
	#tween.tween_property($Startscreen/Control/LogoRofa, "scale", Vector2(1.0,1.0), 1.0)
	#tween.tween_callback(title.queue_free)
	_read_instruction_set()
	description.clear()
	description.add_text(attributes_dict[0])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if Input.is_action_just_pressed("Escape"):
			get_tree().quit() # default behavior


func _read_instruction_set():
	var parser = XMLParser.new()
	parser.open("res://assets/content.xml")
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			attributes_dict = {}
			attributes_dict[0] = parser.get_attribute_value(0)
			for idx in range(1,parser.get_attribute_count()):
				attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
				button = Button.new()
				button.custom_minimum_size = Vector2(300,100) 
				button.add_theme_font_size_override("font_size", 20)
				button.text =attributes_dict[str(idx)]
				var button_id=attributes_dict[str(idx)]
				button.pressed.connect(self._button_pressed.bind(button_id))
				v_box_container.add_child(button)

			print("The ", node_name, " element has the following attributes: ", attributes_dict)
			
func _button_pressed(id):
	print(str(id))
	Globals.instruction_shown = str(id)
	$Startscreen.set_visible(false)
	get_parent().add_child(instruction_set.instantiate())
