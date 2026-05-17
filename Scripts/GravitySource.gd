class_name GravitySource
extends Node2D

@export var circ : DrawCircle
@export var texAffected : Texture2D
@export var texAffectedAlt : Texture2D
@export var texUnaffected : Texture2D
var texAffectedCur : Texture2D
@export var smoothMod : SmoothModulate
var affectedPrev : bool
var affectStateT : float
@export var affectTexFlipDur : float
@export var rotSpeed : float
var rotDir : int

var influenceRadius : float # radius where the force >= discardThreshold

const discardThreshold : float = 170000 # forces below this threshold will not be applied
const gravConstant : float = 7000
const gravPow : float = 2
var _mass : float
var _hasAtmosphere : bool
func _enter_tree():
	smoothMod.a=Persistent.c.lineGravity(false)
	smoothMod.b=Persistent.c.lineGravity(true)
	texAffectedCur=texAffected
	rotDir = 1 if randf()>0.5 else -1
	if randf()>0.5:
		circ.scale.x*=-1
	if randf()>0.5:
		circ.scale.y*=-1
	circ.rotation_degrees=randf()*360
	#visualUpdate()

func _ready():
	visualUpdate()

func updateMass(newMass : float):
	_mass=newMass
	influenceRadius=sqrt((gravConstant*_mass)/discardThreshold)
	circ.Radius(influenceRadius)
func updateAtmosphere(newHasAtmosphere : bool):
	_hasAtmosphere=newHasAtmosphere
func _physics_process(delta):
	if _affected!=affectedPrev:
		affectStateT=0
		visualUpdate()
	affectStateT+=delta
	if _affected:
		if affectStateT>=affectTexFlipDur:
			affectStateT-=affectTexFlipDur
			if texAffectedCur==texAffected:
				texAffectedCur=texAffectedAlt
			else:
				texAffectedCur=texAffected
		circ.texture=texAffectedCur
	else:
		circ.rotation_degrees+=rotDir*rotSpeed*delta
	affectedPrev=_affected
	_affected=false

func visualUpdate():
	if _affected:
		smoothMod.TriggerToA()
		circ.modulate.a=0.6
		circ.texture=texAffected
	else:
		smoothMod.TriggerToB()
		circ.modulate.a=0.4
		circ.texture=texUnaffected


var _affected : bool
func affect(otherGlobalPosition : Vector2, delta : float, projectile : Projectile):
	var dist = global_position.distance_to(otherGlobalPosition)
	if dist > influenceRadius:
		return Vector2.ZERO
	var force = gravConstant*(_mass/pow(dist,gravPow))
	projectile.gravitySources.append(self)
	if projectile.ignoredOrigin==self:
		return Vector2.ZERO
	_affected=true
	return otherGlobalPosition.direction_to(global_position)*force*delta
