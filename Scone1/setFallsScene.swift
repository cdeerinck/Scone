//
//  setFallsScene.swift
//  Scone1
//
//  Created by Chuck Deerinck on 5/30/19.
//  Copyright © 2019 Chuck Deerinck. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

func setFallsScene(scene: SCNScene, node geometryNode:inout SCNNode, view sceneView:SCNView) {
    cleanupAnyMess(scene: scene, node: &geometryNode)
    var elevations:[[CGFloat]] = Array(repeating: Array(repeating:CGFloat(0), count:12), count:12)
    for x in 1...10 {
        for y in 1...10 {
            elevations[x][y] = CGFloat(5 + (6 * cos(Double(x)/2) + (4 * cos(Double(y)/2))))
        }
    }
    for x in 1...10 {
        for y in 1...10 {
            let boxGeometry = SCNBox(width: 1.0, height: 10.0/*elevations[x][y]*/, length: 1.0, chamferRadius: 0.0)
            boxGeometry.firstMaterial?.diffuse.contents = UIColor(red: CGFloat(x)/10, green: CGFloat(y)/10, blue: elevations[x][y]/10, alpha: 0.9)
            let boxNode = SCNNode(geometry: boxGeometry)
            boxNode.position = SCNVector3Make(Float(x) * 1.1 - 6.0, Float((elevations[x][y])/2), Float(y) * 1.1 - 6.0)
            boxNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: boxNode, options: nil))
            geometryNode.addChildNode(boxNode)
        }
    }

    //make balls
    for ballHeight in 0...5000 {
        let ballNode = SCNNode(geometry: SCNSphere(radius: 0.3))
        ballNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "redBlueFlames.jpeg")
        ballNode.position = SCNVector3Make(Float.random(in: -5.0...5.0), 20.0 + Float(ballHeight) , Float.random(in: -5.0...5.0))
        ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: ballNode.geometry!, options: nil))
        geometryNode.addChildNode(ballNode)
    }
    scene.rootNode.addChildNode(geometryNode)
    sceneView.autoenablesDefaultLighting = true
    sceneView.allowsCameraControl = true
    sceneView.showsStatistics = true
    print(scene)
}
