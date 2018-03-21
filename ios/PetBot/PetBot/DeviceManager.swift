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
    
    private let arm: ArmDevice
    private let chassis: ChassisDevice
    
    // MARK: Initialization
    
    init(armAddress: String, chassisAddress: String) {
        self.arm = ArmDevice()
        self.chassis = ChassisDevice()
        
        self.arm.connectToDevice(atAddress: armAddress)
        self.chassis.connectToDevice(atAddress: chassisAddress)
    }
}
