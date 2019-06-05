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

func cleanupAnyMess (scene: inout SCNScene)  {
    cleanup(scene, scene.rootNode)
    scene.background.contents = nil
    //scene = SCNScene()
}

func cleanup (_ scene: SCNScene, _ node:SCNNode) {
    while node.childNodes.count > 0 {
        cleanup(scene, node.childNodes.first!)
    }
    if node != scene.rootNode {
        node.removeFromParentNode()
    }
}
