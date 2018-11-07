//
//  AddNewViewController.swift
//  Dedication App
//
//  Created by Franz on 10/11/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddNewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var dismiss: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var vcLabel: UILabel!
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    var currentTask:Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentTask = currentTask {
            
            vcLabel.text = "UPDATE"
            titleTextField.text = currentTask.title
            startDateTextField.text = currentTask.startdate
            endDateTextField.text = currentTask.enddate
            descTextView.text = currentTask.desc
        }
        

        descTextView.delegate = self
        
        titleTextField.delegate = self
        
        textFieldChanged(startDateTextField)
        textFieldChanged(endDateTextField)
        updateSaveButtonState()
    }

    override func viewDidAppear(_ animated: Bool) {
        titleTextField.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func dismissBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func textFieldChanged(_ textField: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = .date
        if textField == startDateTextField {
            startDateTextField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
        }else if textField == endDateTextField {
            endDateTextField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
        }
        

    }
    
    @objc func startDateChanged(_ sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let dateStr = dateFormatter.string(from: sender.date)
        startDateTextField.text = dateStr
        }
    
    @objc func endDateChanged(_ sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let dateStr = dateFormatter.string(from: sender.date)
        endDateTextField.text = dateStr
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        
        let taskDict: [String: Any] = ["title": titleTextField.text ?? "", "startdate": startDateTextField.text ?? "", "enddate": endDateTextField.text ?? "", "desc": descTextView.text ?? "", "priorties": 5 ]
        
        let theTask = Task(dictionary: taskDict)
        if let currentTask = currentTask {
            theTask.id = currentTask.id
            FirebaseManager.share.updateTask(theTask)
            
            let updated = self.storyboard?.instantiateViewController(withIdentifier: "updated")
            present(updated!, animated: true, completion: nil)
        }
        else {
            FirebaseManager.share.createNewTask(theTask)
            dismiss(animated: true)
        }
    }
    
}
