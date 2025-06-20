extends CharacterBody2D

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING: int = 25

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var enemies_collision_area = $CollisionArea2D
@onready var health_bar = $HealthBar #progressbar

var number_colliding_bodies: int = 0

func _ready() -> void:
	enemies_collision_area.body_entered.connect(on_body_entered)
	enemies_collision_area.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	
	update_health_display()


func _process(delta: float) -> void:
	var movemrnt_vector = get_movement_vector()
	var direction = movemrnt_vector.normalized()
	var target_velocity = direction * MAX_SPEED
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped(): return
	health_component.damage(1 * number_colliding_bodies)
	damage_interval_timer.start()
	print("❤️: ", health_component.current_health)


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()
	
	
func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1
	
	
func on_damage_interval_timer_timeout():
	check_deal_damage()
	
	
func on_health_changed():
	update_health_display()
