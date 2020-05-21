extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var BULLET = preload("res://fire-cube.tscn")

export(NodePath) var pathToCamera


# Called when the node enters the scene tree for the first time.
func generateFireworks() -> void:
	var bullet = BULLET.instance()
	var spell_caster_global_transform = $"fireworksCaster".global_transform
	print(spell_caster_global_transform.basis.z)
	bullet.transform = spell_caster_global_transform
	var translation = $"fireworksCaster".translation
	var target = Vector3.ZERO
	target.x  = translation.x + rand_range(-0.5, 0.5)
	target.z  = translation.z + rand_range(-0.5, 0.5)
	target.y  = translation.y + rand_range(2, 3)
	bullet.define_target(target)
	get_node("/root/game").add_child(bullet)
var fireworksReady = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generateFireworks()


func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		var data = (event as InputEventMouseButton)
		var ray_length = 1000
		var camera = get_node(pathToCamera)
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to)
		if result:
			pass
#			var bullet = BULLET.instance()
#			get_node("/root/game").add_child(bullet)
#			bullet.transform.origin =  result.position
		else:
			print('no hit')
		
		if true:
			pass
	if event is InputEventKey and event.pressed:
		#print(event.scancode,'-', event.unicode)
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fireworksReady:
		fireworksReady = false
		generateFireworks()
