extends Node

const SPAWN_RADIUS: int = 420

@export var basic_enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return
		
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position =  player.global_position + (random_direction * SPAWN_RADIUS)
	
	# Instantiate basic enemy node into the scene
	var enemy = basic_enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null: return
	entities_layer.add_child(enemy) #add the scene as child node of "Main" node
	enemy.global_position = spawn_position
	
