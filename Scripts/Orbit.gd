class_name Orbit
extends Node2D

const orbitCirclePath : String = "res://Scenes/OrbitCircle.tscn"
@export var clockwise : bool = true
@export var cycleDuration : float = 10
const opacity = 0.35
var cycleT : float

@export var satellites : Array[Node2D]
var satelliteOffsets : Array[Vector2]
var circles : Array[OrbitCircle]
var distances : Array[float]

func _enter_tree():
	var temp : Array[Node2D] = satellites.duplicate()
	satellites.clear()
	for s in temp:
		addSatellite(s)
	add_to_group("orbit")
func addSatellite(child : Node2D):
	if satellites.has(child):
		return
	if child is Planet:
		child.moving = true
	satellites.append(child)
	satelliteOffsets.append(global_position-child.global_position)
	var dist = global_position.distance_to(child.global_position)
	if not MathS.HasDistance(distances, dist, 10):
		var circ : DrawCircle = load(orbitCirclePath).instantiate()
		circ.Radius(dist)
		if not clockwise:
			circ.scale*=Vector2(-1,1)
		add_child(circ)
		#circ.modulate=Persistent.c.lineOrbit()
		#circ.modulate.a=opacity
		circles.append(circ)
		distances.append(dist)

func _physics_process(delta):
	if not frozen:
		cycleT+=delta
	if cycleT>cycleDuration:
		cycleT-=cycleDuration
	var rad
	if clockwise:
		rad=deg_to_rad((cycleT/cycleDuration)*360)
	else:
		rad=deg_to_rad((1-(cycleT/cycleDuration))*360)
	for c : DrawCircle in circles:
		c.rotation=rad*1
	for i in range(satellites.size()):
		satellites[i].position=position+satelliteOffsets[i].rotated(rad)

var frozen : bool = false
func freeze():
	frozen = true
	for c in circles:
		c.setFreeze(frozen)
func unfreeze():
	frozen = false
	for c in circles:
		c.setFreeze(frozen)
