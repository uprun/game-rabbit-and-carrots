extends KinematicBody


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var speed = 1.94
var rotation_speed = 90
var moveDirection = Vector3(0, 0, 1)
var velocity = Vector3.FORWARD
var target: Vector3

export(NodePath) var pathToCamera
onready var BULLET = preload("res://fire-cube.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = translation

func getMouseClick3d(data: InputEventMouseButton) -> Dictionary:
	var ray_length = 1000
	var camera = get_node(pathToCamera)
	var from = camera.project_ray_origin(data.position)
	var to = from + camera.project_ray_normal(data.position) * ray_length
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [self])
	return result

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		var data = (event as InputEventMouseButton)
		if data.pressed and data.button_index == 2:
			var result = getMouseClick3d(data)
			target = result.position
			pass
		if data.pressed and data.button_index == 1:
			var result = getMouseClick3d(data)
			if result:
				var bullet = BULLET.instance()
				
				var spell_caster_global_transform = $"staff/spell-caster".global_transform
				print(spell_caster_global_transform.basis.z)
				bullet.transform = spell_caster_global_transform
				bullet.define_target(result.position)
				get_node("/root/game").add_child(bullet)
				#bullet.transform.origin =  result.position
			else:
				print('no hit')
			
			if true:
				pass
	if event is InputEventKey and event.pressed:
		#print(event.scancode,'-', event.unicode)
		pass


func _physics_process(delta: float) -> void:
	velocity.y -= 9.8 * delta
	var vector_to_target =  (target - translation)
	if( vector_to_target.length() > .2):
		
		
		var target_vector = vector_to_target.normalized()
		var new_direction = (target_vector * speed * 5 * delta + velocity).normalized()
		velocity = new_direction * speed
		look_at(target, Vector3.UP)
		move_and_slide(velocity)
