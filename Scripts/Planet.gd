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
@export var spPatternBack : Sprite2D
@export var spPatternFront : Sprite2D
@export var squash : SquashAnchor

@export var grassPacked : PackedScene


func isOccupied():
	return tree!=null

func treeOccupiedSetup(_tree : FruitTree):
	tree=_tree
	level.occupiedPlanets+=1
	spSolid.modulate=Persistent.c.foliage()
	spPatternFront.visible=false
	spPatternBack.visible=false

	squash.TriggerSquash(SquashAnchor.Small*0.85)

	var grass : Grass = grassPacked.instantiate()
	grass.setup(self)
	squash.add_child(grass)

func _enter_tree():
	var colShape : CollisionShape2D = get_child(0)
	shape=colShape.shape

	var uvOffset : Vector2 = Vector2(randf(),randf())*0.75
	Persistent.setupPattern(spPatternBack, Vector2(randf(),randf())*0.75)
	Persistent.setupPattern(spPatternFront, Vector2(randf(),randf())*0.75)
	spSolid.modulate=Persistent.c.rock(0)
	spPatternBack.modulate=Persistent.c.rock(1)
	spPatternFront.modulate=Persistent.c.rock(2)

	spPatternBack.rotation_degrees=randf()*360
	spPatternBack.flip_h=randf()>0.5
	spPatternBack.flip_v=randf()>0.5
	spPatternFront.rotation_degrees=randf()*360
	spPatternFront.flip_h=randf()>0.5
	spPatternFront.flip_v=randf()>0.5


func _ready():
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
	spPatternFront.scale=Vector2.ONE*0.4*(radius/100)
	spPatternBack.scale=Vector2.ONE*0.4*(radius/100)
	shape.radius=radius
