extends Button


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
var gameStarted = false
export(NodePath) var pathToCamera

func _ready() -> void:
	text = "start"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Buttonrestart_pressed() -> void:
	if gameStarted:
		get_tree().reload_current_scene()
		
	else:
		gameStarted = true
		var shared_vars = get_node("/root/SharedVariables")
		shared_vars.isMenuOpen = false
		get_node(pathToCamera).current = true
		visible = false
		text = "re-start"
