//
//  ViewController.swift
//  Scone1
//
//  Created by Chuck Deerinck on 12/23/18.
//  Copyright © 2018 Chuck Deerinck. All rights reserved.
//
//  Keynote presentation is here: https://www.dropbox.com/s/rtgn4c0i72okqy2/SceneKit.key?dl=0

import Foundation
import UIKit
import SceneKit

extension UIImage {
    convenience init?(fromUrl: String) {

        guard let url = URL(string: fromUrl) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

class ViewController: UIViewController {
    
    var scene = SCNScene()
    var geometryNode: SCNNode = SCNNode()
    var cycle:Int = 0
    var mazeBall:SCNNode?
    var sways = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
    enum deligateType {
        case maze
        case tree
        case falls
    }
    var deligateSwitch = deligateType.falls
    var frames:Int = 0

    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.scene = scene
        setCubeScene(scene: &scene, node: &geometryNode, view:sceneView)
    }

    @IBAction func changeScene(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        sceneView.delegate = nil
        sceneView.rendersContinuously = false
        cleanupAnyMess(scene: &scene)
        sceneView.scene = scene
        mazeBall = nil
        switch sender.titleForSegment(at: sender.selectedSegmentIndex) {
        case "Cube":
            setCubeScene(scene: &scene, node: &geometryNode, view: sceneView)
        case "Falls":
            setFallsScene(scene: &scene, node: &geometryNode, view: sceneView)
            sceneView.rendersContinuously = true
            deligateSwitch = deligateType.falls
            sceneView.delegate = self
        case "Tree":
            setTreeScene(scene: &scene, node: &geometryNode, view: sceneView)
            sceneView.rendersContinuously = true
            deligateSwitch = deligateType.tree
            sceneView.delegate = self
        case "Pie":
            setPieScene(scene: &scene, node: &geometryNode, view: sceneView)
        case "Maze":
            mazeBall = setMazeScene(scene: &scene, node: &geometryNode, view: sceneView)
            sceneView.rendersContinuously = true
            deligateSwitch = deligateType.maze
            sceneView.delegate = self
        case "Scratch":
            setScratchScene(scene: &scene, node: &geometryNode, view: sceneView, cycle: &cycle)
        default:
            print(sender.titleForSegment(at: sender.selectedSegmentIndex)!)
        }
    }

    func sway(node:SCNNode, depth:Int) {
        sways[depth] += 0.0001
        let theta = sways[depth]
        let sinTheta = Float(sin(theta)) * 0.01
        if depth>2 {
            node.pivot =  SCNMatrix4MakeTranslation(0,0,0)
            let old = node.eulerAngles
            node.eulerAngles = SCNVector3Make(old.x + sinTheta, old.y + sinTheta, old.z + sinTheta)
        }
        if depth<10 {
            for child in node.childNodes {
                sway(node: child, depth:depth+1)
            }
        }
        //print(depth)
    }

}

extension ViewController: SCNSceneRendererDelegate {

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        frames+=1
        switch deligateSwitch {
        case .maze:
            let ball = mazeBall!
            if let cameraOrientation = sceneView.pointOfView?.position {
                let v:Float = -0.01
                let awayFromCamera = SCNVector3(cameraOrientation.x*v, 0, cameraOrientation.z*v)
                //Push the ball away from the camera
                ball.physicsBody?.applyForce(awayFromCamera, asImpulse: true)
            }
        case .tree:
            sway(node:scene.rootNode.childNodes[scene.rootNode.childNodes.count - 1], depth:0)
        case .falls:
            sceneView.scene?.rootNode.childNodes(passingTest: {
                (node, stop) -> Bool in
                if node.name == "Ball" || node.name == "Popcorn" {
                    if node.presentation.position.y < -100 {
                    node.removeFromParentNode()
                        return true
                    } else {
                        if frames > 100 && node.name == "Ball" && abs(node.physicsBody!.velocity.x)<0.001 && abs(node.physicsBody!.velocity.y)<0.001 && abs(node.physicsBody!.velocity.z)<0.001 {
                            //Make popcord!
                            node.geometry = SCNSphere(radius: 0.5)
                            node.physicsBody?.physicsShape = SCNPhysicsShape(geometry: SCNSphere(radius: 0.5))
                            node.name = "Popcorn"
                            //Or make go away!
                            //node.removeFromParentNode()
                            return true
                        }
                    }
                }
                return false
            })
        }
    }
}

