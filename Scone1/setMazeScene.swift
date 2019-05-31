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

func setMazeScene(scene: SCNScene, node geometryNode:inout SCNNode, view sceneView:SCNView) {

    let size = 15
    let offset = 0 - size / 2
    var m = Array(repeating: Array(repeating: 0, count:size+2), count: size+2)

    func generateMaze(size:Int) -> (maxX:Int, maxY:Int) {

        //directions are 1=right, 2=down, 3=left, 4=up, 5=1, 6=2, 7=3, 8=4, 0=unvisited, -1=stop
        let h = [ 0, 1, 0, -1, 0, 1, 0, -1, 0]
        let v = [ 0, 0, 1, 0, -1, 0, 1, 0, -1]
        var maxDepth = 0
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

    cleanupAnyMess(scene: scene, node: &geometryNode)

    let pillar = SCNCylinder.init(radius: 0.1, height:1.0)
    let wall = SCNBox.init(width: 0.1, height: 1.0, length: 0.9, chamferRadius: 0.05)

    fill(&m, 0...size+1, 0...size+1, with:-1)
    fill(&m, 1...size, 1...size, with:0)
    let maximums = generateMaze(size: size)
    print("Maximums=", maximums)

    //draw the player
    let ballNode = SCNNode(geometry: SCNSphere(radius: 0.3))
    ballNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "redBlueFlames.jpeg")
    ballNode.position = SCNVector3Make(Float(offset+maximums.maxX)+0.5, Float(offset+maximums.maxY)+0.5, 0.5)
    geometryNode.addChildNode(ballNode)
    //draw boundary box
    for y in 1...size+1 {
        for x in 1...size+1 {
            print(m[x][y], terminator: " ")
            //place a pillar
            let pillarNode = SCNNode(geometry: pillar)
            pillarNode.position = SCNVector3Make(Float(offset + x), Float(offset + y), 0.5)
            pillarNode.rotation = SCNVector4(x:1.0, y:0.0, z:0.0, w:Float.pi/2)
            geometryNode.addChildNode(pillarNode)
            //place the top wall
            if x<size+1 && m[x][y] != 4 && m[x][y-1] != 2 {
                let wallNode = SCNNode(geometry: wall)
                wallNode.position = SCNVector3Make(Float(offset + x) + 0.5, Float(offset + y), 0.4)
                wallNode.rotation = SCNVector4(x:0.0, y:1.0, z:0.0, w:Float.pi / 2.0)
                //rotate the flames
                wallNode.pivot = SCNMatrix4MakeRotation(-Float.pi / 2.0, 0.0, 0.0, 1.0) // Angle, x, y, z
                wallNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blueFlame.jpeg")
                geometryNode.addChildNode(wallNode)

            }
            //place the side wall
            if y<size+1 && m[x][y] != 3 && m[x-1][y] != 1 {
                let wallNode = SCNNode(geometry: wall)
                wallNode.position = SCNVector3Make(Float(offset + x), Float(offset + y) + 0.5, 0.4)
                wallNode.rotation = SCNVector4(x:0.0, y:0.0, z:1.0, w:0)
                //rotate the flames
                wallNode.pivot = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0) // Angle, x, y, z
                wallNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blueFlame.jpeg")
                geometryNode.addChildNode(wallNode)
            }
        }
        print("\n")
    }
    scene.rootNode.addChildNode(geometryNode)
    sceneView.autoenablesDefaultLighting = true
    sceneView.allowsCameraControl = true
    sceneView.showsStatistics = true

}
