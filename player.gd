extends KinematicBody


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var speed = 1.94
var rotation_speed = 90
var moveDirection = Vector3(0, 0, 1)
var velocity = Vector3.FORWARD
var target: Vector3

var carrotsCount = 0
var maxCarrots = 0
export(NodePath) var pathToCamera
export(NodePath) var labelPath
onready var BULLET = preload("res://fire-cube.tscn")
onready var paw_prints = preload("res://paw-prints.tscn")
var timer = 0
var winFireforksCount = 4
# Called when the node enters the scene tree for the first time.
func generateFireworks() -> void:
	var bullet = BULLET.instance()
	var spell_caster_global_transform = $"fireworksCaster".global_transform
	print(spell_caster_global_transform.basis.z)
	bullet.transform = spell_caster_global_transform
	var target = Vector3.ZERO
	target.x  = translation.x + rand_range(-0.5, 0.5)
	target.z  = translation.z + rand_range(-0.5, 0.5)
	target.y  = translation.y + rand_range(2, 3)
	bullet.define_target(target)
	get_node("/root/game").add_child(bullet)
	
func _ready() -> void:
	target = translation



func addCarrot() -> void:
	generateFireworks()
	carrotsCount += 1
	get_node(labelPath).text = "carrots " + str(carrotsCount) + "/" + str(maxCarrots)
	if carrotsCount >= maxCarrots:
		generateFireworks()
		generateFireworks()
		generateFireworks()
		generateFireworks()
		generateFireworks()
	
func increaseMaxCarrots() -> void:
	maxCarrots += 1
	get_node(labelPath).text = "carrots " + str(carrotsCount) + "/" + str(maxCarrots)

func getMouseClick3d(data: InputEventMouseButton) -> Dictionary:
	var ray_length = 1000
	var camera = get_node(pathToCamera)
	var from = camera.project_ray_origin(data.position)
	var to = from + camera.project_ray_normal(data.position) * ray_length
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [self])
	return result

func get_vector_to_target() -> Vector3:
	var look_at_target = Vector3.ZERO
	look_at_target.x = target.x
	look_at_target.y = translation.y
	look_at_target.z = target.z
	var vector_to_target =  (look_at_target - translation)
	return vector_to_target

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		var data = (event as InputEventMouseButton)
		if data.pressed and data.button_index == 1:
			var result = getMouseClick3d(data)
			if result:
				target.x = result.position.x
				target.z = result.position.z
				if velocity.length() <= 0.2:
					var prepared_velocity = -transform.basis.z.normalized() * speed
					velocity.x = prepared_velocity.x
					velocity.z = prepared_velocity.z
		if data.pressed and data.button_index == 2:
			var result = getMouseClick3d(data)
			if result:
				pass
#				var bullet = BULLET.instance()
#
#				var spell_caster_global_transform = $"staff/spell-caster".global_transform
#				print(spell_caster_global_transform.basis.z)
#				bullet.transform = spell_caster_global_transform
#				bullet.define_target(result.position)
#				get_node("/root/game").add_child(bullet)
			else:
				print('no hit')
			
			if true:
				pass
	if event is InputEventKey and event.pressed:
		#print(event.scancode,'-', event.unicode)
		pass



func _physics_process(delta: float) -> void:
	timer += delta
	if timer > 1:
		if carrotsCount >= maxCarrots and winFireforksCount > 0:
			winFireforksCount -= 1
			generateFireworks()
			generateFireworks()
			generateFireworks()
		timer = 0
	velocity.y -= 9.8 * delta
	var vector_to_target = get_vector_to_target()
	if( vector_to_target.length() > .2):
		
		if is_on_floor():
			print("jump", timer)
			velocity.y = 5
			var paw_prints_instance = paw_prints.instance()
			var spell_caster_global_transform = global_transform
			paw_prints_instance.transform = spell_caster_global_transform
			get_node("/root/game").add_child(paw_prints_instance)
		
		var target_vector = vector_to_target.normalized()
		var new_direction = (target_vector * speed * 5 * delta + velocity).normalized()
		velocity = new_direction * speed
		var direction_look_at = translation + velocity
		direction_look_at.y = translation.y
		
		look_at(direction_look_at, Vector3.UP)
		var velocity_after = move_and_slide(velocity, Vector3.UP)
		velocity_after.y = velocity.y
		velocity = velocity_after
	else:
		var new_velocity = Vector3.ZERO
		new_velocity.y = velocity.y
		velocity = move_and_slide(new_velocity, Vector3.UP)
