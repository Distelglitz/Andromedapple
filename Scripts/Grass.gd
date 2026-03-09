class_name Grass
extends Node2D

@export var radiusOffset : float
@export var line : Line2D
@export var pointFrequency : float

@export var flowerPacked : PackedScene
@export var flowerSurfaceFrequency : float

@export var flowerInsideFrequencyPer10k : float

@export var sproutDuration : float

func setup(planet : Planet):
	if randf()>0.5:
		scale*=Vector2(-1,1)
	if randf()>0.5:
		scale*=Vector2(1,-1)
	rotation_degrees=randf()*360
	line.modulate=Persistent.c.foliage()
	var radius = planet.radius+radiusOffset
	var circ = 2*PI*radius
	var area = PI*pow(radius,2)
	var pointCount : int = int(circ*pointFrequency)
	var linePoints : Array[Vector2]
	for i in range(pointCount):
		var p : float = float(i)/float(pointCount)
		linePoints.append(Vector2.UP.rotated(2*PI*p)*radius)
	linePoints.append(Vector2.UP*radius)
	line.points=linePoints
	
	var sMat : ShaderMaterial = line.material
	sMat.set_shader_parameter("radius",planet.radius)
	
	var flowerSurfaceCount : int = ceili(circ*flowerSurfaceFrequency)
	for i in range(flowerSurfaceCount):
		var p : float = float(i)/float(flowerSurfaceCount)
		if i==0:
			p=0
		spawnFlowerSurface(Vector2.UP*radius,randf(),p*sproutDuration)
		
	var flowerInsideCount : int = ceili((area*flowerInsideFrequencyPer10k)/10000)
	for i in range(flowerInsideCount):
		var p : float = float(i)/float(flowerInsideCount)
		spawnFlowerInside(radius,p*sproutDuration)


func spawnFlowerSurface(rotateVec : Vector2, p : float, delay : float):
	var flower : Flower = flowerPacked.instantiate()
	add_child(flower)
	flower.position=rotateVec.rotated(2*PI*p)
	flower.setup(delay,true)
	flower.rotation_degrees=p*360

func spawnFlowerInside(radius : float, delay : float):
	var flower : Flower = flowerPacked.instantiate()
	add_child(flower)
	flower.position=Vector2.UP.rotated(2*PI*randf())*radius*randf()
	flower.setup(delay,false)
	flower.rotation_degrees=randf()*360
