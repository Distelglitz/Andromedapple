class_name Debree
extends Area2D

var shaker : Shaker
var sp : Sprite2D
var spOutline : Sprite2D

const outineWidth : float = 0.4
const minVol : float = 2
const maxVol : float = 25
const minLayer : int = 0
const maxLayer : int = 100


func _enter_tree():
	collision_layer=2
	collision_mask=0
	shaker=get_child(1)
	sp=shaker.get_child(0)
	spOutline=shaker.get_child(1)
	
	if scale.x < 0:
		scale.x = -scale.x
	if scale.y < 0:
		scale.y = -scale.y
	
	var vol = scale.x * scale.y
	vol = clamp(vol, minVol, maxVol)
	var p = inverse_lerp(minVol, maxVol, vol)
	z_index = 0
	sp.z_index = lerp(minLayer, maxLayer, 1-p)
	sp.modulate = Persistent.c.wood().lerp(Persistent.c.rock(2), 1-p)
	spOutline.z_index = minLayer-1


	spOutline.scale = Vector2.ONE +  (Vector2.ONE * outineWidth) / scale


func hitByProj(projectile : Projectile):
	shaker.Trigger()
