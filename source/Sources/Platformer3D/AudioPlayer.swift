//
//  AudioPlayer.swift
//
//
//  Created by Alex Loren on 5/19/24.
//

import SwiftGodot

@Godot
class AudioPlayer: Node {
    // MARK: - Properties
    var numberOfPlayers: Int = 12
    var busName = "master"
    var availablePlayers: [AudioStreamPlayer] = []
    var queue: [String] = []
    var random = RandomNumberGenerator()
    
    // MARK: - Functions
    
    /// Called when the `AudioPlayer` enters the tree.
    override func _ready() {
        for i in 0...numberOfPlayers {
            var player = AudioStreamPlayer()
            addChild(node: player)
            
            player.volumeDb = -10
            player.bus = StringName(busName)
            player.finished.connect {
                self.availablePlayers.append(player)
            }
            availablePlayers.append(player)
        }
        GD.print("Loaded \(availablePlayers.count - 1) AudioStreamPlayers")
    }
    
    /// Called every frame to process updates.
    /// - Parameter delta: The time between the last frame and now.
    override func _process(delta: Double) {
        guard !availablePlayers.isEmpty && !queue.isEmpty else {
            return
        }
        
        var next = availablePlayers[0]
        GD.print("Attempting to play audio from path: \(queue[0])")
        next.stream = GD.load(path: queue.removeFirst())
        next.pitchScale = random.randfRange(from: 0.9, to: 1.1)
        next.play()
        availablePlayers.removeFirst()
    }
    
    /// Adds a sound to the queue to be played when a `AudioStreamPlayer` becomes available.
    /// - Parameter path: The resource path of the sound to be played.
    public func play(_ path: String) {
        GD.print("Adding audio path \(path) to the queue.")
        queue.append(path)
    }
}
