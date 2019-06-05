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



func setCubeScene(scene:inout SCNScene, node rootNode:inout SCNNode, view sceneView: SCNView) {

    func makeArrow(node rootNode:SCNNode) -> SCNNode {
        let arrowShaft = SCNNode(geometry: SCNCylinder(radius: 0.5, height: 20.0))
        let arrowHead = SCNNode(geometry: SCNCone(topRadius: 0.0, bottomRadius: 1.0, height: 2.0))
        arrowHead.position = SCNVector3(0.0, 10.0, 0.0) //Move it to the end
        arrowHead.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        arrowShaft.addChildNode(arrowHead) //Add the Arrowhead onto the Arrowshaft
        rootNode.addChildNode(arrowShaft) //Add the entire Arrow to the root
        return arrowShaft //and return it, so we can change it's color and position it.
    }

    func addAxis() {

        let xPlusAxis = makeArrow(node: rootNode)
        xPlusAxis.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 1, green: 0, blue: 0, alpha: 0.8)
        xPlusAxis.position = SCNVector3(10,0,0)
        xPlusAxis.rotation = SCNVector4Make(0,0,1, -(Float.pi/2))

        let yPlusAxis = makeArrow(node: rootNode)
        yPlusAxis.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 0, green: 1, blue: 0, alpha: 0.8)
        yPlusAxis.position = SCNVector3(0,10,0)

        let zPlusAxis = makeArrow(node: rootNode)
        zPlusAxis.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 0, green: 0, blue: 1, alpha: 0.8)
        zPlusAxis.position = SCNVector3(0,0,10)
        zPlusAxis.rotation = SCNVector4Make(1,0,0, Float.pi/2)
    }

    //Create a primitive
    let boxGeometry = SCNBox(width: 10.0, height: 10.0, length: 10.0, chamferRadius: 1.0)
    //Create a node with it
    let boxNode = SCNNode(geometry: boxGeometry)
    // The two above steps could also have been combined as let boxNode = SCNNode(geometry: SCNBox(witdh:...
    //Add this node to our rootNode
    rootNode.addChildNode(boxNode)
    //Add the rootNode to our scene
    scene.rootNode.addChildNode(rootNode)
    //Do some stuff so we don't have to get into the details of Lights, Camera, Action
    addAxis()
    sceneView.autoenablesDefaultLighting = true
    sceneView.allowsCameraControl = true
    sceneView.showsStatistics = false
}
