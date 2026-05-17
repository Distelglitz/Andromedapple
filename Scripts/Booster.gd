class_name Booster
extends Node2D

var area : Area2D
var tog : SmoothToggle
@export var rotSpeed : float

@export var spOuter : Sprite2D
@export var spPulsate : Sprite2D
var p : float
@export var easeM : MathS.EasingMethod
@export var pulsateSpeed : float

func _enter_tree():
    area=get_child(0)
    tog=get_child(1)
    area.body_entered.connect(onBodyEntered)
    eventConnected=false
    if randf()>0.5:
        rotSpeed*=-1
    flipCol()
    spOuter.flip_h = randf() > 0.5
    spOuter.flip_v = randf() > 0.5
    spPulsate.flip_h = spOuter.flip_h
    spPulsate.flip_v = spOuter.flip_v

var eventConnected : bool

func onBodyEntered(other : Node2D):
    if not other is Projectile:
        return
    var p : Projectile = other
    p.resetFreeze()
    p.boost()
    tog.TriggerOff()
    area.set_deferred("monitoring",false)
    var parA : ParSelfFreeCPU = ParticleSpawner.SpawnFromName("BoosterCollect", position)
    var parB : ParSelfFreeCPU = ParticleSpawner.SpawnFromName("BoosterCollect", position)
    parA.modulate = Persistent.c.fruit()
    parB.modulate = Persistent.c.fruitDetail()
    
    if not eventConnected:
        p.level.EV_ProjectileRemoved.connect(onProjectileRemoved)
        eventConnected=true

func onProjectileRemoved(projectile:Projectile,destroyed:bool,other:Node2D):
    tog.TriggerOn()
    area.monitoring=true

func _process(delta: float):
    rotation_degrees+=rotSpeed*delta
    p=MathS.Clamp01(p+delta*pulsateSpeed)
    if p == 1:
        flipCol()
        p = 0
    spPulsate.scale = Vector2.ONE * MathS.Clamp01(MathS.Ease(p, easeM))

func flipCol():
    if spOuter.modulate == Persistent.c.fruitDetail():
        spOuter.modulate = Persistent.c.fruit()
        spPulsate.modulate = Persistent.c.fruitDetail()
    else:
        spOuter.modulate = Persistent.c.fruitDetail()
        spPulsate.modulate = Persistent.c.fruit()