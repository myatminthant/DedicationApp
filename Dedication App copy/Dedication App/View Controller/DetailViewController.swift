//
//  DetailViewController.swift
//  Dedication App
//
//  Created by Franz on 10/10/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startdateLabel: UILabel!
    @IBOutlet weak var enddateLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var bgView: UIView!
    
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    var detailTask: Task!
    var interactor:Interactor? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = detailTask.title
        startdateLabel.text = detailTask.startdate
        enddateLabel.text = detailTask.enddate
        descTextView.text = detailTask.desc
        
        viewShadow()
    }
    
    func viewShadow() {
        bgView.layer.masksToBounds = false
        bgView.layer.shadowColor = UIColor.gray.cgColor
        bgView.layer.shadowOpacity = 1
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowRadius = 5
        
        bgView.layer.cornerRadius = 3
    }
    
    @IBAction func editTask(_ sender: Any) {
        
        performSegue(withIdentifier: "editSegue", sender:detailTask)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let dest = segue.destination as? AddNewViewController
            dest?.currentTask = sender as? Task
        }
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        
        let percentThreshold:CGFloat = 0.3
        
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    
    @IBAction func dismissBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cellDelete(_ sender: UIButton) {
        FirebaseManager.share.deleteTask(detailTask)
        dismiss(animated: true, completion: nil)
    }
    
}
