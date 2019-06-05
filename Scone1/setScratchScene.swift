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

func setScratchScene(scene:inout SCNScene, node:inout SCNNode, view sceneView:SCNView, cycle:inout Int) {
    
    //Shamelessly borrowed from a Ray Wenderlich tutorial.
    //remove all starting here
    switch cycle%4 {
    case 0:
        var x:Float = 0.0
        let radius:CGFloat = 1.0
        let numberOfSpheres = 20

        for i in 1...numberOfSpheres {
            let sphereGeometry = SCNSphere(radius: radius)

            if (i % 2 == 0) {
                sphereGeometry.firstMaterial?.diffuse.contents = UIColor.orange
            } else {
                sphereGeometry.firstMaterial?.diffuse.contents = UIColor.purple
            }

            let sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position = SCNVector3(x: x, y: 0.0, z: 0.0)

            node.addChildNode(sphereNode)

            x += 3 * Float(radius)
        }
    case 1:
        var x:Float = 0.0
        var radius:CGFloat = 1.0
        let numberOfSpheres = 20

        for i in 0..<numberOfSpheres {

            let sphereGeometry = SCNSphere(radius: radius)

            if (i % 2 == 0) {
                sphereGeometry.firstMaterial?.diffuse.contents = UIColor.orange
            } else {
                sphereGeometry.firstMaterial?.diffuse.contents = UIColor.purple
            }

            let sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position = SCNVector3(x: x, y: 0.0, z: 0.0)

            node.addChildNode(sphereNode)

            x += Float(radius)
            radius -= 0.05
            x += Float(radius)
        }
    case 2:
        var y:Float = 0.0
        let radius:CGFloat = 1.0
        let yCount = 20
        let xCount = 20
        for row in 0..<yCount {
            var x:Float = 0.0
            for column in 0..<xCount {
                let sphereGeometry = SCNSphere(radius: radius)

                if (row + column) % 2 == 0 {
                    sphereGeometry.firstMaterial?.diffuse.contents = UIColor.orange
                } else {
                    sphereGeometry.firstMaterial?.diffuse.contents = UIColor.purple
                }

                let sphereNode = SCNNode(geometry: sphereGeometry)
                sphereNode.position = SCNVector3(x: x, y: y, z: Float((row + column) % 2))

                node.addChildNode(sphereNode)

                x += 2 * Float(radius)
            }
            y += 2 * Float(radius)
        }
    case 3:
        var y:Float = 0.0
        let radius:CGFloat = 1.0
        let yCount = 20
        let xCount = 20
        for row in 0..<yCount {
            var x:Float = 0.0
            for column in 0..<xCount {
                let sphereGeometry = SCNSphere(radius: radius)

                sphereGeometry.firstMaterial?.diffuse.contents = row & column != 0 ? UIColor.purple : UIColor.orange


                let sphereNode = SCNNode(geometry: sphereGeometry)
                sphereNode.position = SCNVector3(x: x, y: y, z: row & column != 0 ? 0 : 1)

                node.addChildNode(sphereNode)

                x += 2 * Float(radius)
            }
            y += 2 * Float(radius)
        }
    default:
        break
    }
    cycle += 1
    //Remove all ending here

    scene.rootNode.addChildNode(node)
    sceneView.autoenablesDefaultLighting = true
    sceneView.allowsCameraControl = true
    sceneView.showsStatistics = true
}
