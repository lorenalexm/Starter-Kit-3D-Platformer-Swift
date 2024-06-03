//
//  Player.swift
//
//
//  Created by Alex Loren on 5/19/24.
//

import SwiftGodot
import Numerics

@Godot
class Player: CharacterBody3D {
    // MARK: - Properties
    var animator: AnimationPlayer?
    var audio: AudioPlayer?
    var movementVelocity = Vector3.zero
    var rotationDirection = 0.0
    var gravity = 0.0
    var previouslyFloored = false
    var singleJump = true
    var doubleJump = true
    var coins = 0
    var particlesTrail: CPUParticles3D?
    var soundFootsteps: AudioStreamPlayer?
    var character: Node3D?
    
    #signal("coinCollected", arguments: ["count": Int.self])
    
    @Export(.nodeType, "CameraView") var view: CameraView?
    @Export var movementSpeed: Double = 250
    @Export var jumpStrength: Int = 7
    
    // MARK: - Functions
    
    /// Called when the `CharacterBody3D` has been made ready in the scene.
    override func _ready() {
        character = getNode(path: "Character") as? Node3D
        particlesTrail = getNode(path: "ParticlesTrail") as? CPUParticles3D
        soundFootsteps = getNode(path: "SoundFootsteps") as? AudioStreamPlayer
        animator = getNode(path: "Character/AnimationPlayer") as? AnimationPlayer
        audio = getTree()?.root?.getNode(path: "GlobalAudioPlayer") as? AudioPlayer
    }
    
    /// Called every physics tick to process updates.
    /// - Parameter delta: The time between the last frame and now.
    override func _physicsProcess(delta: Double) {
        handleControls(delta: delta)
        handleGravity(delta: delta)
        handleEffects()
        
        var appliedVelocity = velocity.lerp(to: movementVelocity, weight: delta * 10)
        appliedVelocity.y = Float(-gravity)
        velocity = appliedVelocity
        moveAndSlide()
        
        if Vector2(x: velocity.z, y: velocity.x).length() > 0 {
            rotationDirection = Vector2(x: velocity.z, y: velocity.x).angle()
        }
        rotation.y = Float(GD.lerpAngle(from: Double(rotation.y), to: rotationDirection, weight: delta * 10))
        
        if position.y < -10 {
            getTree()?.reloadCurrentScene()
        }
        
        guard let character else {
            GD.pushError("Player is unable to find the Character!")
            return
        }
        
        character.scale = character.scale.lerp(to: Vector3.one, weight: delta * 10)
        
        if isOnFloor() && gravity > 2 && previouslyFloored == false {
            guard let audio else {
                GD.pushError("Player is unable to find the GlobalAudioPlayer!")
                return
            }
            audio.play("res://sounds/jump.ogg")
            character.scale = Vector3(x: 1.25, y: 0.75, z: 1.25)
        }
        previouslyFloored = isOnFloor()
    }
    
    /// Processes input received from the input device.
    /// - Parameter delta: The time between the last frame and now.
    func handleControls(delta: Double) {
        guard let view = view else {
            GD.pushError("Player does not hold a reference to the View node!")
            return
        }
        
        var input = Vector3.zero
        input.x = Float(Input.getAxis(negativeAction: "move_left", positiveAction: "move_right"))
        input.z = Float(Input.getAxis(negativeAction: "move_forward", positiveAction: "move_back"))
        input = input.rotated(axis: .up, angle: Double(view.rotation.y)).normalized()
        movementVelocity = input * movementSpeed * delta
        
        if Input.isActionJustPressed(action: "jump") == true {
            guard let audio else {
                GD.pushError("Player is unable to find the GlobalAudioPlayer!")
                return
            }
            audio.play("res://sounds/jump.ogg")
            
            if doubleJump == true {
                jump()
                doubleJump = false
            }
            
            if singleJump == true {
                jump()
                singleJump = false
                doubleJump = true
            }
        }
    }
    
    /// Processes the effects of gravity on the `Player`.
    /// - Parameter delta: The time between the last frame and now.
    func handleGravity(delta: Double) {
        gravity += 25 * delta
        
        if gravity > 0 && isOnFloor() == true {
            singleJump = true
            gravity = 0
        }
    }
    
    /// Processes the particles, animation, and sound effects.
    func handleEffects() {
        guard let animator else {
            GD.pushError("Player does not hold a reference to the AnimationPlayer node!")
            return
        }
        
        guard let particlesTrail else {
            GD.pushError("Player is unable to find the ParticlesTrail!")
            return
        }
        
        guard let soundFootsteps else {
            GD.pushError("Player is unable to find the SoundFootsteps!")
            return
        }
        
        particlesTrail.emitting = false
        soundFootsteps.streamPaused = true
        
        if isOnFloor() == true {
            if abs(velocity.x) > 1 || abs(velocity.z) > 1 {
                animator.play(name: "walk", customBlend: 0.5)
                particlesTrail.emitting = true
                soundFootsteps.streamPaused = false
            } else {
                animator.play(name: "idle", customBlend: 0.5)
            }
        } else {
            animator.play(name: "jump", customBlend: 0.5)
        }
    }
    
    /// Scales the `Character` and sets the gravity.
    func jump() {
        guard let character else {
            GD.pushError("Player is unable to find the Character!")
            return
        }
        
        gravity = Double(-jumpStrength)
        character.scale = Vector3(x: 0.5, y: 1.5, z: 0.5)
    }
    
    /// Increments the number of coins and emits a collected signal.
    func collectCoin() {
        coins += 1
        emit(signal: Player.coinCollected, coins)
    }
}
