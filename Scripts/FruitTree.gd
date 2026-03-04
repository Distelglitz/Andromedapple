class_name FruitTree
extends Node2D

@export var cameraHeight : float = 100
@export var packedFruit : PackedScene
@export var spawnPoints : Node2D

@export var trunkHolder : Node2D
@export var leafPacked : PackedScene

@export var tog : SmoothToggle
@export var parPacked : PackedScene

func _enter_tree():
	pass

func _ready():
	var par : CPUParticles2D = parPacked.instantiate()
	par.rotation_degrees=-90
	par.modulate=Persistent.c.foliage()
	add_child(par)
		
	var selectedTrunkIdx : int
	selectedTrunkIdx = randi_range(0,trunkHolder.get_child_count()-1)
	var selectedTrunk : Sprite2D  = trunkHolder.get_child(selectedTrunkIdx)
	selectedTrunk.self_modulate=Persistent.c.wood()
	if randf()>0.5:
		selectedTrunk.scale*=Vector2(-1,1)
	for c : Node2D in selectedTrunk.get_children():
		var leaf : Node2D = leafPacked.instantiate()
		c.add_child(leaf)
	selectedTrunk.visible=true
	tog.TriggerOn()
	for sp : Node2D in spawnPoints.get_children():
		level.spawnFruit(packedFruit, self, sp.position)

var level : Level
