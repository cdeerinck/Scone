//
//  setCubeScene.swift
//  Scone1
//
//  Created by Chuck Deerinck on 5/30/19.
//  Copyright © 2019 Chuck Deerinck. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

func setCubeScene(scene: SCNScene, node:inout SCNNode, view sceneView: SCNView) {
    cleanupAnyMess(scene: scene, node: &node)
    let boxGeometry = SCNBox(width: 10.0, height: 10.0, length: 10.0, chamferRadius: 1.0)
    let boxNode = SCNNode(geometry: boxGeometry)
    node.addChildNode(boxNode)
    scene.rootNode.addChildNode(node)
    sceneView.autoenablesDefaultLighting = true
    sceneView.allowsCameraControl = true
    sceneView.showsStatistics = false
}
