//
//  CameraView.swift
//
//
//  Created by Alex Loren on 5/20/24.
//

import SwiftGodot
import Numerics

@Godot
class CameraView: Node3D {
    // MARK: - Properties
    var cameraRotation = Vector3.zero
    var zoom = 10.0
    
    #exportGroup("Properties")
    @Export(.nodeType, "Player") var target: Player?
    #exportGroup("Zoom")
    @Export var minimumZoom: Double = 16
    @Export var maximumZoom: Double = 4
    @Export var zoomSpeed: Int = 10
    #exportGroup("Rotation")
    @Export var rotationSpeed: Int = 120
    
    var camera: Camera3D?
    
    // MARK: - Functions
    
    /// Called when the `Node3D` has been made ready in the scene.
    override func _ready() {
        camera = getNode(path: "Camera") as? Camera3D
        cameraRotation = rotationDegrees
    }
    
    /// Called every physics tick to process updates.
    /// - Parameter delta: The time between the last frame and now.
    override func _physicsProcess(delta: Double) {
        guard let target else {
            GD.pushError("CameraView does not hold a reference to the Target node!")
            return
        }
        
        guard let camera else {
            GD.pushError("CameraView does not hold a reference to the Camera node!")
            return
        }
        
        position = position.lerp(to: target.position, weight: delta * 4)
        rotationDegrees = rotationDegrees.lerp(to: cameraRotation, weight: delta * 6)
        camera.position = camera.position.lerp(to: Vector3(x: 0, y: 0, z: Float(zoom)), weight: delta * 8)
    }
    
    /// Processes the input to rotate and zoom the `Camera`.
    /// - Parameter delta: The time between the last frame and now.
    func handleInput(delta: Double) {
        var input = Vector3.zero
        input.y = Float(Input.getAxis(negativeAction: "camera_left", positiveAction: "camera_right"))
        input.x = Float(Input.getAxis(negativeAction: "camera_up", positiveAction: "camera_down"))
        
        cameraRotation = input.limitLength(1.0) * rotationSpeed * delta
        cameraRotation.x = cameraRotation.x.clamped(to: -80 ... -10)
        
        zoom += Input.getAxis(negativeAction: "zoom_in", positiveAction: "zoom_out")
        zoom.clamped(to: maximumZoom...minimumZoom)
    }
}
