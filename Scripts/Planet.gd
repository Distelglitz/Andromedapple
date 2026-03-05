class_name Planet
extends Area2D

var level : Level
const density : float = 300
var radius : float
var mass : float
var grav : GravitySource
var tree : FruitTree
var shape : CircleShape2D

@export var spSolid : Sprite2D
@export var spCracks : Sprite2D
@export var squash : SquashAnchor
var cracksMat : ShaderMaterial

func isOccupied():
	return tree!=null

func treeOccupiedSetup(_tree : FruitTree):
	tree=_tree
	level.occupiedPlanets+=1
	spSolid.modulate=Persistent.c.foliage()
	spCracks.visible=false
	squash.TriggerSquash(SquashAnchor.Small*0.85)

func _enter_tree():
	var colShape : CollisionShape2D = get_child(0)
	shape=colShape.shape

	spCracks.rotation_degrees=randf()*360
	spCracks.flip_h=randf()>0.5
	spCracks.flip_v=randf()>0.5
	cracksMat=spCracks.material
	var crackUvOffset : Vector2 = Vector2(randf(),randf())*0.75
	cracksMat.set_shader_parameter("crackUvOffset",crackUvOffset)

func _ready():
	spSolid.modulate=Persistent.c.fruitDetail()
	setRadius(scale.x*100)
	scale=Vector2.ONE

func _physics_process(delta):
	pass


func setRadius(_radius):
	radius=_radius
	mass=density*pow(radius,2)
	if grav==null:
		grav=level.spawnGravitySource(self,Vector2.ZERO,mass,true)
	spSolid.scale=Vector2.ONE*0.4*(radius/100)
	spCracks.scale=Vector2.ONE*0.4*(radius/100)
	shape.radius=radius
