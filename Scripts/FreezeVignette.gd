extends ColorRect

@export var game : Game

var target : float
@export var decaySpeed : float
func _process(delta):
	if game.gameState == Game.GameState.Track and game.selectedProjectile != null and is_instance_valid(game.selectedProjectile):
		var freezeP = game.selectedProjectile.freezePVisual()
		if freezeP > target:
			target = freezeP
		else:
			target = max(freezeP, target - delta * decaySpeed)
	else:
		target = max(0, target - delta * decaySpeed)

	get_parent().position = Persistent.currentCameraPos
	get_parent().scale = Vector2.ONE / Persistent.currentCameraZoom

	if target == 0:
		visible = false
	else:
		material.set_shader_parameter("p", target)
		visible = true
