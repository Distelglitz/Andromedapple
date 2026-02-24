class_name Planet
extends Area2D

var level : Level
const density : float = 300
var radius : float
var mass : float
var grav : GravitySource
var tree : FruitTree
var sp : Sprite2D
var shape : CircleShape2D
func isOccupied():
	return tree!=null

func treeOccupiedSetup(_tree : FruitTree):
	tree=_tree
	level.occupiedPlanets+=1
	sp.modulate=Persistent.c.foliage()

func _enter_tree():
	var colShape : CollisionShape2D = get_child(0)
	shape=colShape.shape
	sp=get_child(1)

func _ready():
	sp.modulate=Persistent.c.fruitDetail()
	setRadius(scale.x*100)
	scale=Vector2.ONE

func _physics_process(delta):
	pass


func setRadius(_radius):
	radius=_radius
	mass=density*pow(radius,2)
	if grav==null:
		grav=level.spawnGravitySource(self,Vector2.ZERO,mass,true)
	sp.scale=Vector2.ONE*0.4*(radius/100)
	shape.radius=radius
