//
//  setPieScene.swift
//  Scone1
//
//  Created by Chuck Deerinck on 5/30/19.
//  Copyright © 2019 Chuck Deerinck. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

func setPieScene(scene: SCNScene, node geometryNode:inout SCNNode, view sceneView:SCNView) {
    cleanupAnyMess(scene: scene, node: &geometryNode)

    let org = CGPoint(x:0, y:0)
    let bp = UIBezierPath.init(arcCenter: org, radius: 10.0, startAngle: 0.0, endAngle: CGFloat.pi/4, clockwise: true)
    bp.flatness = 0.03
    bp.addLine(to: org)
    bp.addLine(to:CGPoint(x:10,y:0))
    //let imageMaterial = SCNMaterial()
    //imageMaterial.diffuse.contents = UIImage(named: "rivetMetal.jpg")
    let pie = SCNShape.init(path: bp, extrusionDepth: 2.0)
    //pie.firstMaterial?.diffuse.contents = UIImage(named: "rivetMetal.jpg")
    pie.firstMaterial?.diffuse.contents = UIImage.init(fromUrl: "https://i.imgur.com/w5rkSIj.jpg")
    let pieNode = SCNNode(geometry: pie)
    //pieNode.rotation = SCNVector4Make(1,1,1,1)

    //make a ball
    let ballNode = SCNNode(geometry: SCNSphere(radius: 1.0))
    ballNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blueFlame.jpg")
    ballNode.position = SCNVector3Make(7, 10, 0)

    pieNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: pieNode, options: nil))
    ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: ballNode.geometry!, options: nil))

    geometryNode.addChildNode(pieNode)
    geometryNode.addChildNode(ballNode)
    scene.rootNode.addChildNode(geometryNode)

    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3Make(0.0, 10.0, 20.0)
    cameraNode.camera?.automaticallyAdjustsZRange = true
    print(cameraNode.position)
    scene.rootNode.addChildNode(cameraNode)

    scene.rootNode.addChildNode(geometryNode)
    sceneView.autoenablesDefaultLighting = true
    sceneView.allowsCameraControl = true
    sceneView.showsStatistics = true

}
