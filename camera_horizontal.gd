extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export(NodePath) var pathToPlayer
var initial_translation: Vector3
var initial_offset: Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_translation = translation
	initial_offset = get_node(pathToPlayer).translation - initial_translation

func _physics_process(delta: float) -> void:
	translation = get_node(pathToPlayer).translation - initial_offset
