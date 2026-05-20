class_name OrbitCircle
extends DrawCircle

@export var texFrozen : Texture2D
@export var texUnfrozen : Texture2D
@export var opacityFrozen : float
@export var opacityUnfrozen : float

func _enter_tree():
    setFreeze(false)

func setFreeze(freeze : bool):
    if freeze:
        texture = texFrozen
        modulate=Persistent.c.lineOrbitFrozen()
        modulate.a = opacityFrozen
    else:
        texture = texUnfrozen
        modulate=Persistent.c.lineOrbit()
        modulate.a = opacityUnfrozen