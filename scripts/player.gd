extends CharacterBody3D

@export var walk_speed: float = 5.0
@export var sprint_speed: float = 10.0
@export var crouch_speed: float = 3.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var camera_x_rotation: float = 0.0
var speed: float = 5.0
var is_crouching: bool = false
var standing_height: float = 2.0
var crouch_height: float = 1.0
var current_height: float = 2.0

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    standing_height = collision_shape.shape.height
    crouch_height = standing_height * 0.5
    
func _input(event):
    if Input.is_action_just_pressed("ui_cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
        var x_delta = event.relative.y * mouse_sensitivity
        camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
        camera.rotation_degrees.x = -camera_x_rotation

func _physics_process(delta):
    # Handle movement states
    if Input.is_action_pressed("sprint") and !is_crouching:
        speed = sprint_speed
    elif is_crouching:
        speed = crouch_speed
    else:
        speed = walk_speed
    
    # Handle crouching
    if Input.is_action_just_pressed("crouch"):
        if !is_crouching:
            is_crouching = true
            # Start crouching transition
            var tween = create_tween()
            tween.tween_property(collision_shape, "shape:height", crouch_height, 0.2)
            tween.parallel().tween_property(mesh_instance, "mesh:height", crouch_height, 0.2)
            tween.parallel().tween_property(head, "position:y", crouch_height * 0.5, 0.2)
        else:
            # Check if there's space to stand up
            if !is_ceiling_above():
                is_crouching = false
                # Start standing transition
                var tween = create_tween()
                tween.tween_property(collision_shape, "shape:height", standing_height, 0.2)
                tween.parallel().tween_property(mesh_instance, "mesh:height", standing_height, 0.2)
                tween.parallel().tween_property(head, "position:y", 1.0, 0.2)
    
    var movement_vector = Vector3.ZERO

    if Input.is_action_pressed("movement_forward"):
        movement_vector -= head.basis.z
    if Input.is_action_pressed("movement_backward"):
        movement_vector += head.basis.z
    if Input.is_action_pressed("movement_left"):
        movement_vector -= head.basis.x
    if Input.is_action_pressed("movement_right"):
        movement_vector += head.basis.x

    movement_vector = movement_vector.normalized()

    velocity.x = lerp(velocity.x, movement_vector.x * speed, acceleration * delta)
    velocity.z = lerp(velocity.z, movement_vector.z * speed, acceleration * delta)

    # Apply gravity
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Jumping (only when not crouching)
    if Input.is_action_just_pressed("jump") and is_on_floor() and !is_crouching:
        velocity.y = jump_power

    move_and_slide()

# Check if there's a ceiling blocking us from standing up
func is_ceiling_above() -> bool:
    var space_state = get_world_3d().direct_space_state
    var query = PhysicsRayQueryParameters3D.create(
        global_position,
        global_position + Vector3(0, standing_height - crouch_height, 0)
    )
    query.exclude = [self]
    var result = space_state.intersect_ray(query)
    return !result.is_empty()

# Optional: footstep sounds (implement separately)
func _on_footstep_timer_timeout():
    if is_on_floor() and velocity.length() > 0.5:
        # Play footstep sound based on speed
        if speed == sprint_speed:
            print("Fast footstep sound")
        elif speed == crouch_speed:
            print("Quiet footstep sound")
        else:
            print("Normal footstep sound")