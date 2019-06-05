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

func setPieScene(scene:inout SCNScene, node geometryNode:inout SCNNode, view sceneView:SCNView) {

    let org = CGPoint(x:0, y:0)
    //Draw a 2D slice of pie
    let bp = UIBezierPath.init(arcCenter: org, radius: 10.0, startAngle: 0.0, endAngle: CGFloat.pi/4, clockwise: true)
    bp.flatness = 0.03 //This controls the smoothness of the curve
    bp.addLine(to: org)
    bp.addLine(to:CGPoint(x:10,y:0))

    let pie = SCNShape.init(path: bp, extrusionDepth: 2.0)
    //let imageMaterial = SCNMaterial()
    //imageMaterial.diffuse.contents = UIImage(named: "rivetMetal.jpg")
    //pie.firstMaterial?.diffuse.contents = UIImage(named: "rivetMetal.jpg")
    pie.firstMaterial?.diffuse.contents = UIImage.init(fromUrl: "https://i.imgur.com/w5rkSIj.jpg")
    let front = SCNMaterial()
    front.diffuse.contents = UIImage.init(fromUrl: "https://i.imgur.com/w5rkSIj.jpg")
    let back = SCNMaterial()
    back.diffuse.contents = UIImage(named: "rivetMetal.jpg")
    let edges = SCNMaterial()
    edges.diffuse.contents = UIImage(named: "redBlueFlames.jpg")
    pie.materials = [front,back,edges]
    //Cube side order: +x, -x, +y, -y, +z, -z
    let pieNode = SCNNode(geometry: pie)

    //make a ball
    let ballNode = SCNNode(geometry: SCNSphere(radius: 1.0))
    //Give it a wrapper
    ballNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blueFlame.jpg")
    //Move it into position
    ballNode.position = SCNVector3Make(7, 10, 0)

    //Tell it that the pie node is fixed
    pieNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: pieNode, options: nil))
    //Tell it that the ball can move
    ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: ballNode.geometry!, options: nil))

    //Add the nodes to our root
    geometryNode.addChildNode(pieNode)
    geometryNode.addChildNode(ballNode)
    scene.rootNode.addChildNode(geometryNode)


    sceneView.autoenablesDefaultLighting = true
    sceneView.showsStatistics = true

    sceneView.allowsCameraControl = true
    let cameraNode = sceneView.pointOfView!
    //    cameraNode.position = SCNVector3Make(0, 6, 15)
    //    cameraNode.rotation = SCNVector4Make(0, 0, 0, 0)
    //    cameraNode.orientation = SCNVector4Make(0, 0, 0, 1)
    //    cameraNode.camera?.fieldOfView = 60.0
    cameraNode.transform = SCNMatrix4(m11: 1.0, m12: 0.0, m13: 0.0, m14: 0.0, m21: 0.0, m22: 1.0, m23: 0.0, m24: 0.0, m31: 0.0, m32: 0.0, m33: 1.0, m34: 0.0, m41: 0.0, m42: 6.0, m43: 15.0, m44: 1.0)
    //This was the cheat way of getting the numbers above
    //print(cameraNode.position)
    //print(cameraNode.rotation)
    //print(cameraNode.orientation)
    //print(cameraNode.camera?.fieldOfView)
    //print(cameraNode.transform)

}
