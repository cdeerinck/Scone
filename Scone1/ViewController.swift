//
//  ViewController.swift
//  Scone1
//
//  Created by Chuck Deerinck on 12/23/18.
//  Copyright © 2018 Chuck Deerinck. All rights reserved.
//

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
    
    let scene = SCNScene()
    var geometryNode: SCNNode = SCNNode()

    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.scene = scene
        setCubeScene(scene: scene, node: &geometryNode, view:sceneView)
    }



    @IBAction func changeScene(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        
        switch sender.titleForSegment(at: sender.selectedSegmentIndex) {
        case "Cube":
            setCubeScene(scene: scene, node: &geometryNode, view: sceneView)
        case "Falls":
            setFallsScene(scene: scene, node: &geometryNode, view: sceneView)
        case "Tree":
            setTreeScene(scene: scene, node: &geometryNode, view: sceneView)
        case "Pie":
            setPieScene(scene: scene, node: &geometryNode, view: sceneView)
        case "Maze":
            setMazeScene(scene: scene, node: &geometryNode, view: sceneView)
        case "Scratch":
            setScratchScene(scene: scene, node: &geometryNode, view: sceneView)
        default:
            print(sender.titleForSegment(at: sender.selectedSegmentIndex)!)
        }
        
    }

    
}

