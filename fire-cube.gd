extends KinematicBody

onready var vfx_explosion = preload("res://vfx-explosion.tscn")

var speed = 16
var rotation_speed = 90
var moveDirection = Vector3(0, 0, 1)
var initial_rotation: Vector3
var initial_transform: Transform
var velocity = Vector3.ZERO
var maxTime = 5

var target: Vector3

var running = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_rotation = self.rotation_degrees
	initial_transform = self.transform
	velocity = initial_transform.basis.z.normalized() * speed
	print("velocity", velocity)
	
func define_target(par_target: Vector3) -> void:
	target = par_target
	
func _physics_process(delta: float) -> void:
	#velocity.y -= 19.8 * delta
	
	if target:
		var target_vector = (target - translation).normalized()
		var new_direction = (target_vector * speed * 5 * delta + velocity).normalized()
		
		velocity = new_direction * speed
	if running:
		move_and_collide(velocity* delta)
	
	maxTime -= delta
	
	if maxTime < 0:
		var explosion = vfx_explosion.instance()
		get_node("/root/game").add_child(explosion)
		explosion.transform = transform
		queue_free()





func _on_Area_body_entered(body: Node) -> void:
	running = false
	print('collision')
	
	maxTime = 0.1
	if body.name.find("enemy") >= 0 or body.name.find("player") >= 0:
		#body.decrease_hp()
		queue_free()
	else:
		#queue_free()
		pass
