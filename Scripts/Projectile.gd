class_name Projectile
extends RigidBody2D

var startPos : Vector2

var level : Level
var ignoredOrigin : GravitySource

var initialDirection : Vector2
@export var boostStrength : float
@export var initialSpeed : float

var gravitySources : Array[GravitySource]
var prevGravitySources : Array[GravitySource]

@export var timeToFreeze : float
var _freezeT : float

@export var colShape : CollisionShape2D
@export var area : Area2D
@export var areaColShape : CollisionShape2D

@export var spMain : Sprite2D
@export var spDetail : Sprite2D

var rotDir : int
@export var baseRotSpeed : float
@export var rotSpeedScale : float
@export var spHolder : Node2D

@export var visualEffectsStart : float

func _enter_tree():
	areaColShape.shape=colShape.shape
	area.area_entered.connect(onAreaEntered)
	rotDir=1 if randf()>0.5 else -1
	fruitColors()
func _ready():
	startPos=global_position

func onAreaEntered(other : Area2D):
	if other is Planet:
		var planet : Planet = other
		if planet.isOccupied():
			level.removeProjectile(self,true,other)
		else:
			level.removeProjectile(self,false,other)
	elif other is Debree:
		var debree : Debree = other
		debree.hitByProj(self)
		level.removeProjectile(self,true,other)
	elif other is Asteroid:
		var asteroid : Asteroid = other
		asteroid.hitByProj(self)
		level.removeProjectile(self,true,other)
func setup(_initialDirection : Vector2, _ignoredOrigin : GravitySource, texMain : Texture2D, texDetail : Texture2D):
	ignoredOrigin=_ignoredOrigin
	initialDirection=_initialDirection
	linear_velocity=initialDirection*initialSpeed
	spMain.texture=texMain
	spDetail.texture=texDetail
	level.EV_ProjectileRemoved.connect(_onProjectileRemoved)

var totalGravStep : Vector2

func freezeP():
	return MathS.Clamp01(_freezeT/timeToFreeze)

func freezePVisual():
	return (max(freezeP()-visualEffectsStart, 0))/(1-visualEffectsStart)

func resetFreeze():
	_freezeT=0
func boost():
	linear_velocity+=linear_velocity.normalized()*boostStrength
func _physics_process(delta):
	linear_velocity+=totalGravStep
	_freezeT+=delta
	totalGravStep=Vector2.ZERO
	for grav : GravitySource in gravitySources:
		if not prevGravitySources.has(grav):
			_onGravitySourceEntered(grav)
		if grav._hasAtmosphere:
			_freezeT=0
	for grav : GravitySource in prevGravitySources:
		if not gravitySources.has(grav):
			_onGravitySourceExited(grav)
	prevGravitySources=gravitySources.duplicate()
	gravitySources.clear()

	if freezeP()==1:
		level.removeProjectile(self,true,null)

func _process(delta):
	spHolder.rotation_degrees+=rotDir*(baseRotSpeed+rotSpeedScale*linear_velocity.length())*delta
	fruitColors()

func _onGravitySourceEntered(gravitySource:GravitySource):
	print("Gravity Source Enter")
func _onGravitySourceExited(gravitySource:GravitySource):
	print("Gravity Source Exit")
	if gravitySource==ignoredOrigin:
		ignoredOrigin=null
		print("Left origin gravity zone")
	else:
		pass
func _onProjectileRemoved(projectile : Projectile, destroyed, other):
	if projectile!=self:
		return
	var parPath : String = "FruitDestroyed" if destroyed else "FruitImpact"
	var parPos = position
	if other is Planet:
		var planet : Planet = other
		parPos = planet.global_position-position.direction_to(planet.global_position)*(planet.radius+25) # makes particle spawn on planet surface
	var pMain : Node2D = ParticleSpawner.SpawnFromName(parPath,parPos)
	pMain.modulate=Persistent.c.fruit()
	
	var pDetail : Node2D = ParticleSpawner.SpawnFromName(parPath,parPos)
	if destroyed:
		pDetail.modulate=Persistent.c.fruitDetail()
	else:
		pDetail.modulate=Persistent.c.fruit()
	level.EV_ProjectileRemoved.disconnect(_onProjectileRemoved)


func gravStep(amount : Vector2, delta : float, gravSource : GravitySource):
	totalGravStep+=amount*delta

func fruitColors():
	var p = freezePVisual()
	spMain.modulate=Persistent.c.fruit().lerp(Persistent.c.freezing(), p)
	spDetail.modulate=Persistent.c.fruitDetail().lerp(Persistent.c.freezing(), p)