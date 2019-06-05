//
//  setTreeScene.swift
//  Scone1
//
//  Created by Chuck Deerinck on 5/30/19.
//  Copyright © 2019 Chuck Deerinck. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

func setTreeScene(scene:inout SCNScene, node geometryNode:inout SCNNode, view sceneView:SCNView) {
    scene.background.contents = [
        "art.scnassets/right.jpg",
        "art.scnassets/left.jpg",
        "art.scnassets/top.jpg",
        "art.scnassets/bottom.jpg",
        "art.scnassets/back.jpg",
        "art.scnassets/front.jpg",
    ]

    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3Make(0.0, 0.0, 100.0)
    //cameraNode.camera?.fieldOfView = 90.0
    //cameraNode.camera?.automaticallyAdjustsZRange = true
    scene.rootNode.addChildNode(cameraNode)

    makeBranch(parent: geometryNode, parentLength: 0.0, bend: 0.0, twist: 0.0, length: 3.0, width: 0.6, step:0, steps:5)

    sceneView.allowsCameraControl = true
    //let cameraNode = sceneView.pointOfView!
    cameraNode.position = SCNVector3Make(-7.4117355, 5.94650674, 15.626298)
    cameraNode.rotation = SCNVector4(x: -0.0048316754, y: -0.9999876, z: -0.0015077204, w: 0.6049566)
    cameraNode.orientation = SCNVector4(x: -0.0014392927, y: -0.29788318, z: -0.00044913014, w: 0.95460117)
    cameraNode.camera!.fieldOfView = 45.0

    scene.rootNode.addChildNode(geometryNode)
    sceneView.autoenablesDefaultLighting = true
    sceneView.showsStatistics = true
}

func makeBranch(parent:SCNNode, parentLength:Float, bend: Float, twist:Float, length:Float, width:CGFloat, step:Int, steps:Int) {
    //Make the leaf or pivot point
    let leafGeometry = SCNSphere(radius: width*5.0) //SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.2)
    leafGeometry.firstMaterial?.diffuse.contents = UIColor(red: 1.0, green: 0.0, blue: 0, alpha: 0.5)
    var leafNode:SCNNode
    if step == steps {
        leafNode = SCNNode(geometry: leafGeometry)
    } else {
        leafNode = SCNNode()
    }
    leafNode.position = SCNVector3Make(0.0, parentLength/2, 0.0)
    parent.addChildNode(leafNode)
    if step == steps { return }
    //Make the branch
    //let branchGeometry = SCNCylinder(radius: width, height: CGFloat(length))
    let branchGeometry = SCNCone(topRadius: width/2, bottomRadius: width, height: CGFloat(length))
    branchGeometry.firstMaterial?.diffuse.contents = UIColor(red: 0.5-0.25*(CGFloat(step)/CGFloat(steps)), green: 0.25+0.35*(CGFloat(step)/CGFloat(steps)), blue: 0.05-0.025*(CGFloat(step)/CGFloat(steps)), alpha: 1.0)
    let branchNode = SCNNode(geometry: branchGeometry)
    branchNode.pivot = SCNMatrix4MakeTranslation(0.0, -length/2, 0.0)
    branchNode.eulerAngles = SCNVector3Make(bend, twist, 0.0)
    leafNode.addChildNode(branchNode)
    if step < steps {
        let branchCount = Int.random(in:3...7)
        let twist = ( Float.pi * 2 ) / Float(branchCount)
        let actualBend = Float.random(in: 0.3...1.0)
        let newLength = length * 0.8
        let newWidth = width * 0.5
        for b in 1...branchCount {
            let actualTwist = Float(b) * twist + Float.random(in: -1...1)
            makeBranch(parent: branchNode, parentLength: length, bend: actualBend, twist: actualTwist, length: newLength, width: newWidth, step: step+1, steps: steps)
        }
    }
}
