//
//  GameUI.swift
//
//
//  Created by Alex Loren on 5/19/24.
//

import SwiftGodot

@Godot
class GameUI: CanvasLayer {
    // MARK: - Properties
    @BindNode var Coins: Label
    
    // MARK: - Functions
    
    /// Called when the `CanvasLayer` has been made ready in the scene.
    override func _ready() {
        guard let player = getTree()?.root?.getNode(path: "Main/Player") else {
            GD.pushError("GameUI does not hold a reference to the Player node!")
            return
        }
        player.connect(signal: Player.coinCollected, to: self, method: "onCoinCollected")
    }
    
    /// Updates the `Coins` label with the new total count.
    /// - Parameter total: The total count of all coins collected.
    @Callable func onCoinCollected(total: Int) {
        GD.print("coinCollected signal received.")
        Coins.text = "\(total)"
    }
}
