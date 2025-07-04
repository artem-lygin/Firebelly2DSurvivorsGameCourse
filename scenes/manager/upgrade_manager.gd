extends Node

@export var upgrades_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades: Dictionary = {
	#to be filled with apply_upgrade method below
}

func _ready() -> void:
	experience_manager.level_up.connect(on_level_up)
	
	
func on_level_up(_current_level: int) -> void:
	@warning_ignore("untyped_declaration")
	var chosen_upgrade = upgrades_pool.pick_random() as AbilityUpgrade
	if chosen_upgrade == null:
		return
	
	var upgrade_screen_instance: Node = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades([chosen_upgrade] as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade: bool = current_upgrades.has(upgrade.upgrade_id)
	if !has_upgrade:
		current_upgrades[upgrade.upgrade_id] = {
			"resourse": upgrade,
			"quantity": 1
		}
	else :
		current_upgrades[upgrade.upgrade_id]["quantity"] += 1
		
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
	# print(current_upgrades)	
