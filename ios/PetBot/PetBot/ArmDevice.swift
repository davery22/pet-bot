//
//  ArmDevice.swift
//  PetBot
//
//  Created by Daniel Avery on 3/20/18.
//  Copyright © 2018 Daniel Avery. All rights reserved.
//

import Foundation

class ArmDevice: Device {
    // MARK: Types
    
    struct ArmIds {
        static let armPitchMotorIdentifier = "arm_pitch_motor"
        static let armReachMotorIdentifier = "arm_reach_motor"
        static let armLaserIdentifier = "laser"
    }
    
    // MARK: Public Methods
    
    func moveArmUp(percent per: Int) {
        self.sendCommand(toDevice: ArmIds.armPitchMotorIdentifier, percent: per)
    }
    
    func moveArmDown(percent per: Int) {
        self.sendCommand(toDevice: ArmIds.armPitchMotorIdentifier, percent: -per)
    }
    
    func stopArmVertical() {
        sendCommand(toDevice: ArmIds.armPitchMotorIdentifier, percent: 0)
    }
    
    func extendArm(percent per: Int) {
        sendCommand(toDevice: ArmIds.armReachMotorIdentifier, percent: per)
    }
    
    func retractArm(percent per: Int) {
        sendCommand(toDevice: ArmIds.armReachMotorIdentifier, percent: -per)
    }
    
    func stopExtendArm() {
        sendCommand(toDevice: ArmIds.armReachMotorIdentifier, percent: 0)
    }
    
    func turnLaserOn() {
        sendCommand(toDevice: ArmIds.armLaserIdentifier, percent: 100)
    }
    
    func turnLaserOff() {
        sendCommand(toDevice: ArmIds.armLaserIdentifier, percent: 0)
    }
}
