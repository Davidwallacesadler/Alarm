//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by David Sadler on 4/7/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Internal Properties
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    var alarmIsOn: Bool = true
    
    // MARK: Internal Methods
    
    private func updateViews() {
        guard let selectedAlarm = alarm else {
            // Default to ON state
            activationButton.titleLabel?.text = "ON"
            activationButton.backgroundColor = UIColor.green
            return
        }
        self.navigationItem.title = selectedAlarm.name
        alarmTitleTextField.text = selectedAlarm.name
        alarmTimePicker.date = selectedAlarm.fireDate
        if selectedAlarm.enabled == true {
            activationButton.setTitle("ON", for: .normal)
            activationButton.backgroundColor = UIColor.green
        } else {
            activationButton.setTitle("OFF", for: .normal)
            activationButton.backgroundColor = UIColor.red
        }
        
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Tap Gesture Regcognizer
        
        // Acts as a resign first responder for the 
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var alarmTitleTextField: UITextField!
    @IBOutlet weak var alarmTimePicker: UIDatePicker!
    @IBOutlet weak var activationButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func activationButtonPressed(_ sender: Any) {
        if alarmIsOn == true {
            alarmIsOn = false
            alarm?.enabled = alarmIsOn
            activationButton.setTitle("OFF", for: .normal)
            activationButton.backgroundColor = UIColor.red
        } else {
            alarmIsOn = true
            alarm?.enabled = alarmIsOn
            activationButton.setTitle("ON", for: .normal)
            activationButton.backgroundColor = UIColor.green
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let alarmName = alarmTitleTextField.text else { return }
        if let alarm = self.alarm {
            AlarmController.shared.updateAlarm(alarm: alarm, fireDate: alarmTimePicker.date, name: alarmName, enabled: alarm.enabled)
        } else {
            AlarmController.shared.addAlarm(fireDate: alarmTimePicker.date, name: alarmName, enabled: alarmIsOn)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
