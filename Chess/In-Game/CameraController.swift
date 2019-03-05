//
//  CameraController.swift
//  Chess
//
//  Created by Mark Pizzutillo on 3/3/19.
//  Copyright © 2019 Mark Pizzutillo. All rights reserved.
//

import Foundation
import SceneKit

class CameraController {
    
    var cameraYaw : SCNNode!
    var cameraPitch : SCNNode!
    var cameraZoom: SCNNode!
    
    struct CameraParameters {
        var position : SCNVector3 = SCNVector3.init()
        var rotation : SCNVector4 = SCNVector4.init()
        var orientation : SCNQuaternion = SCNQuaternion.init()
        var fieldOfView : CGFloat = CGFloat(0)
    }
    
    fileprivate var cameraSaveParams = CameraParameters()
    
    init(scene: SCNScene) {
        
        //Init camera references
        self.cameraYaw = scene.rootNode.childNode(withName: "cameraYaw", recursively: false)!
        self.cameraPitch = self.cameraYaw.childNode(withName: "cameraPitch", recursively: false)!
        self.cameraZoom = self.cameraPitch.childNode(withName: "cameraZoom", recursively: false)!
    }
    
    deinit {
        self.cameraYaw = nil
        self.cameraPitch = nil
        self.cameraZoom = nil
    }
    
    func performCameraYaw(degrees: Float) {
        let rotation = SCNAction.rotate(
            by: CGFloat(GLKMathDegreesToRadians(degrees)),
            around: SCNVector3(0,1,0),
            duration: TimeInterval(abs(degrees) / 90.0))
        
        rotation.timingMode = .easeInEaseOut
        
        cameraYaw.runAction(rotation)
    }
    
    func performCameraPitch(degrees: Float) {
        let rotation = SCNAction.rotate(
            by: (-1) * CGFloat(GLKMathDegreesToRadians(degrees)),
            around: SCNVector3(1,0,0),
            duration: TimeInterval(abs(degrees) / 90.0))
        
        rotation.timingMode = .easeInEaseOut
        
        cameraPitch.runAction(rotation)
    }
    
    func performCameraZoom(amount: Float) {
        let zoom = SCNAction.move(by: SCNVector3(0,0,(-1) * amount), duration: 0.2)
        zoom.timingMode = .easeInEaseOut
        
        cameraZoom.runAction(zoom)
    }
    
    func exitFreeRoam()
    {
        SCNTransaction.animationDuration = 0.5
        
        cameraZoom.position = cameraSaveParams.position
        cameraZoom.rotation = cameraSaveParams.rotation
        cameraZoom.orientation = cameraSaveParams.orientation
        cameraZoom.camera!.fieldOfView = cameraSaveParams.fieldOfView
    }
    
    func enterFreeRoam() {
        self.cameraSaveParams.position = cameraZoom.position
        self.cameraSaveParams.rotation = cameraZoom.rotation
        self.cameraSaveParams.orientation = cameraZoom.orientation
        self.cameraSaveParams.fieldOfView = cameraZoom.camera!.fieldOfView
    }
}
