//
//  ArmViewController.swift
//  PetBot
//
//  Created by Daniel Avery on 3/21/18.
//  Copyright © 2018 Daniel Avery. All rights reserved.
//

import UIKit
import os.log

class ArmViewController: UIViewController {
    // MARK: - Properties
    
    @IBOutlet weak var laserSwitch: UISwitch!
    
    @IBOutlet weak var debugLabel: UILabel!
    var deviceMgr: DeviceManager!
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        if let deviceMgr = deviceMgr {
            self.laserSwitch.isOn = deviceMgr.isLaserOn
        }
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
        case "ToChassis":
            // Pass on the DeviceManager.
            guard let chassisViewController = segue.destination as? ChassisViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            chassisViewController.deviceMgr = self.deviceMgr
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

    // MARK: - Actions
    
    @IBAction func laserSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.deviceMgr.arm.turnLaserOn()
            self.deviceMgr.isLaserOn = true
            self.debugLabel.text = "laser on"
        }
        else {
            self.deviceMgr.arm.turnLaserOff()
            self.deviceMgr.isLaserOn = false
            self.debugLabel.text = "laser off"
        }
    }
    
    @IBAction func armDirectionChanged(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended:
            self.deviceMgr.arm.stopArmVertical()
            self.deviceMgr.chassis.stopArmHorizontal()
            
            //os_log("ended", log: OSLog.default, type: .debug)
            self.debugLabel.text = "arm dir stopped"
        case .changed:
            // Get translation and normalize to a "reasonable" percentage
            var translation = sender.translation(in: sender.view)
            translation.x = translation.x / 5.0
            translation.y = translation.y / 5.0
            
            // Turn arm if translation x outweighs y, else adjust pitch
            if abs(translation.x) > abs(translation.y) {
                let percent = Int(translation.x)
                if percent < 0 {
                    self.deviceMgr.chassis.moveArmLeft(percent: -percent)
                }
                else {
                    self.deviceMgr.chassis.moveArmRight(percent: percent)
                }
            }
            else {
                let percent = Int(translation.y)
                if percent < 0 {
                    self.deviceMgr.arm.moveArmUp(percent: -percent)
                }
                else {
                    self.deviceMgr.arm.moveArmDown(percent: percent)
                }
            }
            
            os_log("arm dir changed (tX: %f, tY: %f)", translation.x, translation.y)
            self.debugLabel.text = "arm dir changed (tX: \(translation.x), tY: \(translation.y))"
        default:
            break
        }
    }
    
    @IBAction func armReachChanged(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended:
            self.deviceMgr.arm.stopExtendArm()
            
            //os_log("ended", log: OSLog.default, type: .debug)
            self.debugLabel.text = "arm reach stopped"
        case .changed:
            // Get translation and normalize to a "reasonable" percentage
            var translation = sender.translation(in: sender.view)
            translation.x = translation.x / 5.0
            translation.y = translation.y / 5.0
            
            // Do nothing if translation x outweighs y, else adjust reach
            if abs(translation.x) > abs(translation.y) {
                break
            }
            else {
                let percent = Int(translation.y)
                if percent < 0 {
                    self.deviceMgr.arm.extendArm(percent: -percent)
                }
                else {
                    self.deviceMgr.arm.retractArm(percent: percent)
                }
            }
            
            os_log("arm reach changed (tX: %f, tY: %f)", translation.x, translation.y)
            self.debugLabel.text = "arm reach changed (tX: \(translation.x), tY: \(translation.y))"
        default:
            break
        }
    }
    
}
