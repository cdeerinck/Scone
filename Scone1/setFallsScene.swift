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

func setFallsScene(scene:inout SCNScene, node geometryNode:inout SCNNode, view sceneView:SCNView) {
    var elevations:[[CGFloat]] = Array(repeating: Array(repeating:CGFloat(0), count:12), count:32)
    for x in 1...30 {
        for y in 1...10 {
            elevations[x][y] = CGFloat(5 + (6 * cos(Double(x)/2) + (4 * cos(Double(y)/2))))
        }
    }
    for x in 1...30 {
        for y in 1...10 {

            let boxGeometry = SCNBox(width: 1.0, height: 10.0/*elevations[x][y]*/, length: 1.0, chamferRadius: 0.0)
            let capsuleGeometry = SCNCapsule(capRadius: 0.6, height: 10)
            let boxNode = SCNNode(geometry: (x+y)%2 == 0 ? boxGeometry: capsuleGeometry)
            boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor(red: CGFloat(x)/10, green: CGFloat(y)/10, blue: elevations[x][y]/10, alpha: 1)
            boxNode.position = SCNVector3Make(Float(x) * 1.1 - 6.0, Float((elevations[x][y])/2), Float(y) * 1.1 - 6.0)
            boxNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: boxNode, options: nil))
            geometryNode.addChildNode(boxNode)
        }
    }

    //make balls
    for ballHeight in 0...4000 {
        let ballNode = SCNNode(geometry: SCNSphere(radius: 0.3))
        ballNode.name = "Ball"
        ballNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "redBlueFlames.jpeg")
        ballNode.position = SCNVector3Make(Float.random(in: -5.0...11.0), 20.0 + Float(ballHeight) , Float.random(in: -5.0...5.0))
        ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: ballNode.geometry!, options: nil))
        geometryNode.addChildNode(ballNode)
    }
    scene.rootNode.addChildNode(geometryNode)

    //let cameraNode = sceneView.pointOfView!
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3Make(10, 19, 9)
    cameraNode.rotation = SCNVector4Make(1,0,0,-1)
    scene.rootNode.addChildNode(cameraNode)
    sceneView.autoenablesDefaultLighting = true
    sceneView.allowsCameraControl = true
    sceneView.showsStatistics = true
}
