//
//  FallingPlatform.swift
//
//
//  Created by Alex Loren on 5/19/24.
//

import SwiftGodot

@Godot
class FallingPlatform: Node3D {
    // MARK: - Properties
    var falling = false
    var gravity = 0.0
    
    // MARK: - Functions
    
    /// Called when the `Node3D` has been made ready in the scene.
    override func _ready() {
        guard let area = self.getNode(path: "Area3D") as? Area3D else {
            GD.pushError("Unable to find the FallingPlatform Area3D node!")
            return
        }
        area.bodyEntered.connect(onBodyEntered)
    }
    
    /// Called every frame to process updates.
    /// - Parameter delta: The time between the last frame and now.
    override func _process(delta: Double) {
        scale = scale.lerp(to: Vector3(x: 1, y: 1, z: 1), weight: delta * 10)
        position.y -= Float(gravity * delta)
        
        if position.y < -10 {
            queueFree()
        }
        
        if falling == true {
            gravity += 0.25
        }
    }
    
    /// Called whenever another body enters into this `Node3D`.
    /// - Parameter body: The other `Node3D` body.
    func onBodyEntered(body: Node3D) {
        guard falling == false else {
            return
        }
        
        scale = Vector3(x: 1.25, y: 1, z: 1.25)
        falling = true
    }
}
