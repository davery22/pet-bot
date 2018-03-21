//
//  DeviceManager.swift
//  PetBot
//
//  Created by Daniel Avery on 3/21/18.
//  Copyright © 2018 Daniel Avery. All rights reserved.
//

import Foundation

class DeviceManager {
    // MARK: Properties
    
    let armAddress: String
    let chassisAddress: String
    let arm: ArmDevice
    let chassis: ChassisDevice
    var isLaserOn: Bool
    
    // MARK: Initialization
    
    init(armAddress: String, chassisAddress: String) {
        self.armAddress = armAddress
        self.chassisAddress = chassisAddress
        self.isLaserOn = false
        self.arm = ArmDevice()
        self.chassis = ChassisDevice()
        
        self.arm.connectToDevice(atAddress: armAddress)
        self.chassis.connectToDevice(atAddress: chassisAddress)
    }
    
    // MARK: Deconstruction
    
    func teardown() {
        
    }
}
