extends KinematicBody


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var velocity: Vector3
var jump = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	translation.y += .2
	get_node("/root/game/player").increaseMaxCarrots()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#rotate_x( 2 * delta)
	rotate_y( 2* delta)

func _physics_process(delta: float) -> void:
	if jump:
		velocity.y -= 9.8 * delta
		velocity = move_and_slide(velocity, Vector3.UP)
		if is_on_floor():
			queue_free()
		

func _on_Area_body_entered(body: Node) -> void:
	print(body.name)
	if(body.name == 'ground2'):
		queue_free()
	if(body.name == 'player'):
		if not jump:
			body.addCarrot()
			velocity.y = 5
			jump = true
	
