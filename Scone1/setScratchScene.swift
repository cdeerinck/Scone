//
//  setScratchScene.swift
//  Scone1
//
//  Created by Chuck Deerinck on 5/30/19.
//  Copyright © 2019 Chuck Deerinck. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

func setScratchScene(scene: SCNScene, node:inout SCNNode, view:SCNView) {
    cleanupAnyMess(scene: scene, node: &node)

}
