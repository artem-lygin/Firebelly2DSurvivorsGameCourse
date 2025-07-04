extends Area2D
class_name HurboxComponent

@export var health_component: HealthComponent


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	@warning_ignore("untyped_declaration")
	var hitbox_component = other_area as HitboxComponent
	
	health_component.damage(hitbox_component.damage_amount)
