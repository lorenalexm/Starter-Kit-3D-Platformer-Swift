//
//  Godot.swift
//
//
//  Created by Alex Loren on 5/19/24.
//

import SwiftGodot

let registeredTypes: [Wrapped.Type] = [
    AudioPlayer.self,
    Player.self,
    Coin.self,
    Cloud.self,
    FallingPlatform.self,
    GameUI.self,
    CameraView.self
]

#initSwiftExtension(cdecl: "swift_entry_point", types: registeredTypes)
