//
//  Coin.swift
//
//
//  Created by Alex Loren on 5/19/24.
//

import SwiftGodot
import Numerics

@Godot
class Coin: Area3D {
	// MARK: - Properties
    var time = 0.0
	var grabbed = false
    @BindNode var Mesh: MeshInstance3D
    @BindNode var Particles: CPUParticles3D

	// MARK: - Functions
    
    /// Called when the `Area3D` has been made ready in the scene.
    override func _ready() {
        self.bodyEntered.connect(onBodyEntered)
    }
    
    /// Called every frame to process updates.
    /// - Parameter delta: The time between the last frame and now.
    override func _process(delta: Double) {
        rotateY(angle: 2 * delta)
        position.y += Float((Double.cos(time * 5) * 1) * delta)
        time += delta
    }
    
    /// Called whenever another body enters into this `Area3D`.
    /// - Parameter body: The other `Node3D` body.
    func onBodyEntered(body: Node3D) {
        guard grabbed == false,
            let player = body as? Player else {
            return
        }
        
        guard let audio = getTree()?.root?.getNode(path: "GlobalAudioPlayer") as? AudioPlayer else {
            GD.pushError("Unable to find the GlobalAudioPlayer!")
            return
        }
        
        player.collectCoin()
        audio.play("res://sounds/coin.ogg")
        Mesh.queueFree()
        Particles.emitting = false
        grabbed = true
    }
}
