extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var timeout = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	timeout -= delta
	if timeout < 0:
		queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
