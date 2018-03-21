//
//  ConnectViewController.swift
//  PetBot
//
//  Created by Daniel Avery on 3/20/18.
//  Copyright © 2018 Daniel Avery. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    
    var previousChassisAddress: String?
    var previousArmAddress: String?
    @IBOutlet weak var armAddressTextField: UITextField!
    @IBOutlet weak var chassisAddressTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text fields' user input through delegate callbacks.
        armAddressTextField.delegate = self
        chassisAddressTextField.delegate = self
        
        if let previousArmAddress = previousArmAddress {
            self.armAddressTextField.text = previousArmAddress
        }
        if let previousChassisAddress = previousChassisAddress {
            self.chassisAddressTextField.text = previousChassisAddress
        }

        // Enable the Connect button only if address fields are valid.
        updateConnectButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateConnectButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Connect button while editing.
        connectButton.isEnabled = false
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Prepare a DeviceManager for the view controllers.
        let deviceMgr = DeviceManager(armAddress: armAddressTextField.text!, chassisAddress: chassisAddressTextField.text!)
        
        guard let chassisViewController = segue.destination as? ChassisViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        chassisViewController.deviceMgr = deviceMgr
    }

    // MARK: - Private Methods
    
    private func updateConnectButtonState() {
        // Only enable the Connect button if both text fields are valid addresses.
        connectButton.isEnabled = isValidIPAddress(armAddressTextField.text ?? "") && isValidIPAddress(chassisAddressTextField.text ?? "")
    }
    
    private func isValidIPAddress(_ address: String) -> Bool {
        let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        return address.range(of: validIpAddressRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
