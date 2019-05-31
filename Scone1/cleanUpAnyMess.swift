//
//  cleanUpAnyMess.swift
//  Scone1
//
//  Created by Chuck Deerinck on 5/30/19.
//  Copyright © 2019 Chuck Deerinck. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

func cleanupAnyMess (scene: SCNScene, node:inout SCNNode)  {
    node.removeFromParentNode()
    node = SCNNode()
    scene.background.contents = []
}
