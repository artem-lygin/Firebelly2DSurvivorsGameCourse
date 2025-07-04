extends CharacterBody2D

const MAX_SPEED = 40 # Basic Enemy speed

@onready var health_component: HealthComponent = $HealthComponent


func _process(_delta: float) -> void:
	var direction: Vector2 = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player() -> Vector2:
	@warning_ignore("untyped_declaration")
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO


func on_area_entered(_other_area: Area2D) -> void:
	health_component.damage(5)
	
