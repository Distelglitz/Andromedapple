class_name Whale
extends Area2D

const maxSpeed : float = 3000
const accelDur : float = 0
const alertDelay : float = 0

var accelT : float

const fov : float = 90
const dist : float = 450000

var bloated : bool
const mass : float = 13000000
const removedEatThreshold : float = 700

@export var colShape : CollisionShape2D
var shape : CircleShape2D
@export var squash : SquashAnchor
@export var shaker : Shaker
@export var rotEaten : Node2D
@export var rotHungry : Node2D

@export var spBody : Sprite2D
@export var spEyes : Sprite2D

@export var texBodyIdle : Texture2D
@export var texEyesIdle : Texture2D

@export var texBodyChase : Texture2D
@export var texEyesChase : Texture2D


@export var rotFin : Node2D
var finT : float
@export var finSwingSpeedMoving : float
@export var finSwingSpeedIdle : float
@export var finSwingMagnitude : float

var level : Level
var proj : Projectile

var velocity : Vector2

var aggro : bool
var hasEaten : bool

var movingPrev : bool
var moving : bool

@export var eatenRotSpeed : float
var eatenRotDir : float

func _enter_tree():
	eatenRotDir = -1 if randf() > 0.5 else 1
	shape = colShape.shape
	hasEaten = false
	level=get_parent().get_parent()
	level.EV_ProjectileSpawned.connect(onProjectileSpawned)
	level.EV_ProjectileRemoved.connect(onProjectileRemoved)
	
	area_entered.connect(onAreaEntered)
	body_entered.connect(onBodyEntered)

	eatenRotDir = -1 if randf() > 0.5 else 1
	rotHungry.rotation=rotation
	rotation=0

func _ready():
	updateVisuals()

func _physics_process(delta):
	movingPrev = moving
	if hasEaten:
		rotEaten.rotation_degrees+=delta*eatenRotDir*eatenRotSpeed
		velocity = Vector2.ZERO
	else:
		moving = movesToTarget()
		var finSpeed : float
		if moving:
			finSpeed=finSwingSpeedMoving
			accelT+=delta
			velocity=position.direction_to(proj.position)*maxSpeed*MathS.Clamp01((accelT-alertDelay)/accelDur)
		else:
			finSpeed=finSwingSpeedIdle
			accelT=0
			velocity=Vector2.ZERO
			if velocity.length()<=20:
				velocity=Vector2.ZERO
		finT+=delta*finSpeed
		rotFin.rotation_degrees = sin(finT)*finSwingMagnitude


	if velocity.length()>20:
		rotHungry.rotation_degrees=MathS.VecToDeg(velocity.normalized())

	position+=velocity*delta

	if moving != movingPrev:
		shaker.Trigger()
		squash.TriggerSquash(SquashAnchor.Small)
		updateVisuals()


func _process(delta):
	if hasEaten:
		pass
	else:
		pass

func updateVisuals():
	spBody.texture = texBodyChase if moving else texBodyIdle
	spEyes.texture = texEyesChase if moving else texEyesIdle

func movesToTarget():
	if proj==null:
		aggro=false
		return false
	var los : bool = lineOfSight()
	if not los:
		aggro=false
	elif not aggro:
		var angleToProj : float = rad_to_deg(position.direction_to(proj.position).angle_to(rotHungry.transform.x))
		if abs(angleToProj)<=fov/2 and proj.position.distance_to(position)<=dist:
			aggro=true
			print("Whale aggro triggered " + str(abs(angleToProj)) + "  " + str(proj.position.distance_to(position)))
	return aggro


func lineOfSight():
	var colMask = 3
	var query = PhysicsRayQueryParameters2D.create(position,proj.position,colMask)
	query.collide_with_areas=true
	query.collide_with_bodies=false
	var spaceState = get_world_2d().direct_space_state
	var result : Dictionary = spaceState.intersect_ray(query)
	return result.is_empty()

func onProjectileSpawned(projectile : Projectile):
	proj=projectile

func onProjectileRemoved(projectile : Projectile, destroyed : bool, other : Node2D):
	proj=null

func onAreaEntered(area : Area2D):
	pass
func onBodyEntered(body : Node2D):
	if body is Projectile:
		level.removeProjectile(body,true,self)
		eat(body)

func eat(projectile : Projectile):
	if hasEaten:
		return
	level.spawnGravitySource(self,Vector2.ZERO,mass, true)
	hasEaten=true
	squash.TriggerSquash(SquashAnchor.Large)

	rotHungry.rotation_degrees=randf()*360
	rotHungry.visible=false
	rotEaten.visible=true
