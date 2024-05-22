//
//  Cloud.swift
//
//
//  Created by Alex Loren on 5/19/24.
//

import SwiftGodot
import Numerics

@Godot
class Cloud: Node3D {
	// MARK: - Properties
	var time = 0.0
	var random = RandomNumberGenerator()
    var randomVelocity = 0.0
    var randomTime = 0.0

	// MARK: - Functions
    
    /// Called when the `Node3D` has been made ready in the scene.
	override func _ready() {
		randomVelocity = random.randfRange(from: 0.1, to: 2)
		randomTime = random.randfRange(from: 0.1, to: 2)
	}

    /// Called every frame to process updates.
    /// - Parameter delta: The time between the last frame and now.
	override func _process(delta: Double) {
        position.y += Float((Double.cos(time * randomTime) * randomVelocity) * delta)
		time += delta
	}
}
