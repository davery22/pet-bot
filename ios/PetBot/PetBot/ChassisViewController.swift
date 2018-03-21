//
//  ChassisViewController.swift
//  PetBot
//
//  Created by Daniel Avery on 3/20/18.
//  Copyright © 2018 Daniel Avery. All rights reserved.
//

import UIKit
import os.log

class ChassisViewController: UIViewController {
    // MARK: - Properties
    
    var deviceMgr: DeviceManager!

    @IBOutlet weak var debugLabel: UILabel!
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "ToArm":
            // Pass on the DeviceManager.
            guard let armViewController = segue.destination as? ArmViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            armViewController.deviceMgr = self.deviceMgr
        case "Disconnect":
            // Populate addresses with previous choices.
            guard let connectViewController = segue.destination as? ConnectViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            connectViewController.previousArmAddress = self.deviceMgr.armAddress
            connectViewController.previousChassisAddress = self.deviceMgr.chassisAddress
            deviceMgr.teardown()
        default:
            // Bug!
            deviceMgr.teardown()
            fatalError("Unexpected Segue Identifier: \(segue.identifier ?? "[null]")")
        }
    }
    
    // MARK: Actions
    
    @IBAction func panReceived(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended:
            self.deviceMgr.chassis.stopWheels()
            
            //os_log("ended", log: OSLog.default, type: .debug)
            self.debugLabel.text = "wheels stopped"
        case .changed:
            // Get translation and normalize to a "reasonable" percentage
            var translation = sender.translation(in: sender.view)
            translation.x = translation.x / 5.0
            translation.y = translation.y / 5.0
            
            // Turn if translation x outweighs y, else go straight
            if abs(translation.x) > abs(translation.y) {
                let percent = Int(translation.x)
                self.deviceMgr.chassis.moveWheels(percentLeft: percent, percentRight: percent)
            }
            else {
                let percent = Int(translation.y)
                self.deviceMgr.chassis.moveWheels(percentLeft: percent, percentRight: -percent)
            }
            
            os_log("wheels changed (tX: %f, tY: %f)", translation.x, translation.y)
            self.debugLabel.text = "wheels changed (tX: \(translation.x), tY: \(translation.y))"
        default:
            break
        }
    }
    
}
