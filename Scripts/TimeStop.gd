class_name TimeStop
extends Node2D

var area : Area2D
var tog : SmoothToggle
@export var sinSpeed : float
@export var sinMag : float
var t : float

@export var spMain : Sprite2D
@export var spDetails : Sprite2D

var level : Level

func _enter_tree():
	area=get_child(0)
	tog=get_child(1)
	area.body_entered.connect(onBodyEntered)
	eventConnected=false
	if randf()>0.5:
		sinSpeed*=-1
	spMain.flip_h = randf() > 0.5
	spMain.flip_v = randf() > 0.5
	spDetails.flip_h = spMain.flip_h
	spDetails.flip_v = spMain.flip_v
	level = get_tree().get_first_node_in_group("level")


var eventConnected : bool

var collectedOnce : bool

func onBodyEntered(other : Node2D):
	if not other is Projectile:
		return
	var p : Projectile = other
	p.resetFreeze()
	collectedOnce = true
	level.orbitFreezeToggle()

	tog.TriggerOff()
	area.set_deferred("monitoring",false)
	var parA : ParSelfFreeCPU = ParticleSpawner.SpawnFromName("TimeStopCollect", position)
	var parB : ParSelfFreeCPU = ParticleSpawner.SpawnFromName("TimeStopCollect", position)
	parA.modulate = Persistent.c.lineOrbit()
	parB.modulate = Persistent.c.lineOrbitFrozen()
	
	if not eventConnected:
		p.level.EV_ProjectileRemoved.connect(onProjectileRemoved)
		eventConnected=true

func onProjectileRemoved(projectile:Projectile,destroyed:bool,other:Node2D):
	if collectedOnce:
		return
	tog.TriggerOn()
	area.monitoring=true

func _process(delta: float):
	t+=delta
	rotation_degrees=sin(sinSpeed*t)*sinMag
