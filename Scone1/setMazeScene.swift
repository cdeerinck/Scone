//
//  setMazeScene.swift
//  Scone1
//
//  Created by Chuck Deerinck on 5/30/19.
//  Copyright © 2019 Chuck Deerinck. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

func setMazeScene(scene:inout SCNScene, node geometryNode:inout SCNNode, view sceneView:SCNView) -> SCNNode {

    let size = 15
    let offset = -1.5 - Float(size / 2)
    var m = Array(repeating: Array(repeating: 0, count:size+2), count: size+2)
    var depth = Array(repeating: Array(repeating: 0, count:size+2), count: size+2)
    var maxDepth = 0

    func generateMaze(size:Int) -> (maxX:Int, maxY:Int) {

        //directions are 1=right, 2=down, 3=left, 4=up, 5=1, 6=2, 7=3, 8=4, 0=unvisited, -1=stop
        let h = [ 0, 1, 0, -1, 0, 1, 0, -1, 0]
        let v = [ 0, 0, 1, 0, -1, 0, 1, 0, -1]
        var curDepth = 0

        var x:Int = Int.random(in:1...size)
        var y:Int = 1
        var maxX:Int = 0
        var maxY:Int = 0

        m[x][y]=4 //says we came in from the top
        while m[x][y] > 0 {
            var d=Int.random(in:1...4)
            //look for a neighboring unvisited room
            while d < 9 && m[x+h[d]][y+v[d]] != 0 {
                d+=1 //Try 90 degrees clockwise
            }
            if d==9 {
                //back out
                depth[x][y]=curDepth
                d = m[x][y]
                x += h[d]
                y += v[d]
                curDepth -= 1
            } else {
                //go into
                x += h[d]
                y += v[d]
                m[x][y] = (((d-1)%4)+2)%4+1 //Given: 12345678, want : 34123412
                curDepth += 1
                if curDepth > maxDepth {
                    maxX = x
                    maxY = y
                    maxDepth = curDepth
                }
            }
        }
        return (maxX, maxY)
    }

    func fill(_ destination:inout [[Int]], _ xRange:ClosedRange<Int>, _ yRange:ClosedRange<Int>, with: Int) {
        for x in xRange {
            for y in yRange {
                destination[x][y]=with
            }
        }
    }

    let wall = SCNBox.init(width: 0.1, height: 0.9, length: 1.0, chamferRadius: 0.05)

    fill(&m, 0...size+1, 0...size+1, with:-1)
    fill(&m, 1...size, 1...size, with:0)
    let maximums = generateMaze(size: size)

    //draw the player
    let ballNode = SCNNode(geometry: SCNSphere(radius: 0.3))
    ballNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "redBlueFlames.jpeg")
    ballNode.position = SCNVector3Make(offset+Float(maximums.maxX)+0.5, 2.5, offset+Float(maximums.maxY)+0.5)
    ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: ballNode.geometry!, options: nil))
    geometryNode.addChildNode(ballNode)
    //draw the ground
    let groundNode = SCNNode(geometry: SCNBox(width: CGFloat(size+2), height: 0.1, length: CGFloat(size+2), chamferRadius: 0.1))
    groundNode.position = SCNVector3Make(0, 0, -0.1)
    groundNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: groundNode, options: nil))

    //groundNode.rotation = SCNVector4Make(1.0, 0.0, 0.0, Float.pi/2)
    groundNode.geometry!.firstMaterial?.diffuse.contents = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.7)
    geometryNode.addChildNode(groundNode)
    //draw boundary box
    for y in 1...size+1 {
        for x in 1...size+1 {
            //place a pillar
            let pillar = SCNCylinder.init(radius: 0.1, height:1.0)
            let pillarNode = SCNNode(geometry: pillar)
            let pillarDepth = CGFloat(depth[x][y] + depth[x-1][y] + depth[x][y-1] + depth[x-1][y-1])/CGFloat(4*maxDepth)
            pillarNode.geometry!.firstMaterial!.diffuse.contents = UIColor(red: pillarDepth, green: 0.0, blue: 1-pillarDepth, alpha: 1.0)
            pillarNode.position = SCNVector3Make(offset + Float(x), 0.5, offset + Float(y))
            //pillarNode.rotation = SCNVector4(x:1.0, y:0.0, z:0.0, w:Float.pi/2)
            groundNode.addChildNode(pillarNode)
            //place the top wall
            if x<size+1 && m[x][y] != 4 && m[x][y-1] != 2 {
                let wallNode = SCNNode(geometry: wall)
                wallNode.position = SCNVector3Make(offset + Float(x) + 0.5, 0.4, offset + Float(y))
                wallNode.rotation = SCNVector4(x:0.0, y:1.0, z:0.0, w:Float.pi / 2.0)
                //rotate the flames
                //wallNode.pivot = SCNMatrix4MakeRotation(-Float.pi / 2.0, 0.0, 0.0, 1.0) // Angle, x, y, z
                wallNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blueFlame.jpeg")
                wallNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: wallNode, options: nil))
                groundNode.addChildNode(wallNode)

            }
            //place the side wall
            if y<size+1 && m[x][y] != 3 && m[x-1][y] != 1 {
                let wallNode = SCNNode(geometry: wall)
                wallNode.position = SCNVector3Make(offset + Float(x), 0.4, offset + Float(y) + 0.5)
                //wallNode.rotation = SCNVector4(x:0.0, y:0.0, z:1.0, w:0)
                //rotate the flames
                //wallNode.pivot = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0) // Angle, x, y, z
                wallNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blueFlame.jpeg")
                wallNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(node: wallNode, options: nil))
                groundNode.addChildNode(wallNode)
            }
        }
    }
    scene.rootNode.addChildNode(geometryNode)

    sceneView.allowsCameraControl = true
    let cameraNode = sceneView.pointOfView!
    cameraNode.position.y = 10 // = SCNVector3(x: 8.174704, y: 53.882057, z: 0.60620534)
    cameraNode.rotation = SCNVector4(x: -0.99453974, y: -0.07641775, z: -0.07107101, w: 1.5037862)
    cameraNode.orientation = SCNVector4(x: -0.6792932, y: -0.052195057, z: -0.048543107, w: 0.73039716)
    cameraNode.camera?.fieldOfView = 46.84557342529297

    let ballConstraint = SCNLookAtConstraint(target: ballNode)
    ballConstraint.influenceFactor = 1
    cameraNode.constraints = [ballConstraint]
    //sceneView.pointOfView!.constraints = [ballConstraint]

    sceneView.autoenablesDefaultLighting = true
    sceneView.showsStatistics = false
    


    return ballNode

}
