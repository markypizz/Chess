//
//  CamerControlsViewController.swift
//  Chess
//
//  Created by Mark Pizzutillo on 3/3/19.
//  Copyright © 2019 Mark Pizzutillo. All rights reserved.
//

import UIKit
import SceneKit.SCNScene

protocol CameraControlDelegate {
    func cameraControlWasEnabled()
    func cameraControlWasDisabled()
}

class CameraControlsViewController: UIViewController {
    
    //Outlets for camera control
    @IBOutlet var dPadButtons: [UIButton]!
    @IBOutlet var zoomButtons: [UIButton]!
    @IBOutlet weak var unlockButton: UIButton!
    
    var cameraController : CameraController!
    
    @IBOutlet weak var controlsView: UIView!
    
    let cameraYawDegrees : Float = 45.0/2
    let cameraZoomAmount : Float = 2.0
    let cameraPitchmount : Float = 15.0
    
    var cameraControlDelegate : CameraControlDelegate!
    
    var freeRoamEnabled = false {
        didSet {
            if freeRoamEnabled {
                enterFreeRoam()
                cameraControlDelegate.cameraControlWasEnabled()
            } else {
                cameraControlDelegate.cameraControlWasDisabled()
                exitFreeRoam()
            }
        }
    }

    override func viewDidLoad() {
        //Background for camera controls
        let controlsBG = UIImage(named: "brightstripeBG")!.cgImage
        
        self.controlsView.backgroundColor = UIColor(patternImage:
            UIImage(cgImage: controlsBG!, scale: 4, orientation: .up))
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cameraControlDelegate = nil
    }
    
    func enterFreeRoam() {
        
        for button in dPadButtons {
            button.isEnabled = false
        }
        
        for button in zoomButtons {
            button.isEnabled = false
        }
        unlockButton.setImage(UIImage(named: "unlock"), for: .normal)
       
        cameraController.enterFreeRoam()
    }
    
    func exitFreeRoam() {
        cameraController.exitFreeRoam()
        
        for button in dPadButtons {
            button.isEnabled = true
        }
        
        for button in zoomButtons {
            button.isEnabled = true
        }
        unlockButton.setImage(UIImage(named: "lock"), for: .normal)
    }
    
    func initCameraController(scene: SCNScene) {
        cameraController = CameraController(scene: scene)
    }
    
    @IBAction func yawRightButtonPressed(_ sender: UIButton) {
        cameraController.performCameraYaw(degrees: cameraYawDegrees)
    }
    
    @IBAction func zoomOutButtonPressed(_ sender: UIButton) {
        cameraController.performCameraZoom(amount: (-1)*cameraZoomAmount)
    }
    
    @IBAction func pitchUpButtonPressed(_ sender: UIButton) {
        cameraController.performCameraPitch(degrees: cameraPitchmount)
    }
    
    @IBAction func pitchDownButtonPressed(_ sender: UIButton) {
        cameraController.performCameraPitch(degrees: (-1)*cameraPitchmount)
    }
    
    @IBAction func zoomInButtonPressed(_ sender: UIButton) {
        cameraController.performCameraZoom(amount: cameraZoomAmount)
    }
    
    @IBAction func yawLeftButtonPressed(_ sender: UIButton) {
        cameraController.performCameraYaw(degrees: (-1)*cameraYawDegrees)
    }
    
    @IBAction func unlockButtonPressed(_ sender: UIButton) {
        freeRoamEnabled = !freeRoamEnabled
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
