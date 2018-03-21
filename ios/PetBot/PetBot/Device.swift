//
//  Device.swift
//  PetBot
//
//  Created by Daniel Avery on 3/20/18.
//  Copyright © 2018 Daniel Avery. All rights reserved.
//

import Foundation

class Device {
    // MARK: Types
    
    struct Constants {
        static let commandsPort = 1234
        static let encoderSteps = 17
    }
    
    // MARK: Properties
    
    private var tcpConnection: TCPConnection
    
    // MARK: Initialization
    
    init() {
        self.tcpConnection = TCPConnection()
    }
    
    // MARK: Public Methods
    
    func connectToDevice(atAddress ipAddress: String) {
        DispatchQueue.global(qos: .utility).async {
            self.tcpConnection.remoteConnect(atAddress: ipAddress, port: Constants.commandsPort)
        }
    }
    
    func sendCommand(toDevice device: String, percent per: Int) {
        let percent = boundPercentage(value: roundToMultipleOfEncoderSteps(value: per))
        let jsonObject: [String: Any] = [
            "device": device,
            "percent": percent
        ]
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.tcpConnection.writeJSONToSocket(json: jsonObject)
        }
    }
    
    // MARK: Private Methods
    
    private func roundToMultipleOfEncoderSteps(value val: Int) -> Int {
        var count = val / Constants.encoderSteps
        let tip = Double(val) / Double(Constants.encoderSteps) - Double(count)
        if val >= 0 {
            count += (tip >= 0.5) ? 1 : 0
        }
        else {
            count += (tip <= -0.5) ? -1 : 0
        }
        return count * Constants.encoderSteps
    }
    
    private func boundPercentage(value val: Int) -> Int {
        if val > 100 {
            return 100
        }
        else if val < -100 {
            return -100
        }
        return val
    }
}
