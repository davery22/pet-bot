//
//  ChassisDevice.swift
//  PetBot
//
//  Created by Daniel Avery on 3/20/18.
//  Copyright © 2018 Daniel Avery. All rights reserved.
//

import Foundation

class ChassisDevice: Device {
    // MARK: Types
    
    struct ChassisIds {
        static let chassisLeftMotorIdentifier = "chassis_left_motor"
        static let chassisRightMotorIdentifier = "chassis_right_motor"
        static let armYawMotorIdentifier = "arm_yaw_motor"
    }
    
    // MARK: Public Methods
    
    func moveArmLeft(percent per: Int) {
        self.sendCommand(toDevice: ChassisIds.armYawMotorIdentifier, percent: per)
    }
    
    func moveArmRight(percent per: Int) {
        self.sendCommand(toDevice: ChassisIds.armYawMotorIdentifier, percent: -per)
    }
    
    func stopArmHorizontal() {
        self.sendCommand(toDevice: ChassisIds.armYawMotorIdentifier, percent: 0)
    }
    
    func moveWheels(percentLeft perL: Int, percentRight perR: Int) {
        self.sendCommand(toDevice: ChassisIds.chassisLeftMotorIdentifier, percent: perL)
        self.sendCommand(toDevice: ChassisIds.chassisRightMotorIdentifier, percent: perR)
    }
    
    func stopWheels() {
        self.sendCommand(toDevice: ChassisIds.chassisLeftMotorIdentifier, percent: 0)
        self.sendCommand(toDevice: ChassisIds.chassisRightMotorIdentifier, percent: 0)
    }
}
