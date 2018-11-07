//
//  ViewController.swift
//  Dedication App
//
//  Created by Franz on 10/9/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var screenCoverBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    let transition = CircularTransition()
    let interactor = Interactor()
    var tasks = [Task]()
    var ref: DatabaseReference!
    let uniqueRandomKey =  (String( Date.timeIntervalSinceReferenceDate ).split(separator: ".").joined() +  String(describing:arc4random_uniform(100000)))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let uniqueUserID = UserDefaults.standard.string (forKey: "userid") ?? uniqueRandomKey
        FirebaseManager.share.userid = uniqueUserID
        
        Auth.auth().signInAnonymously { (result, error) in
            if error != nil {
                UserDefaults.standard.set(uniqueUserID, forKey: "userid")
                UserDefaults.standard.synchronize()
            } else {
                let userid = result?.user.uid
                UserDefaults.standard.set(userid  , forKey: "userid")
                UserDefaults.standard.synchronize()
                FirebaseManager.share.userid = userid ?? uniqueUserID
            }
        }
        
        FirebaseManager.share.observeTask() { tasks in
            
            self.tasks = tasks
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.reloadData()
            self.hideMenu()
        }
      
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            FirebaseManager.share.deleteTask(tasks[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListTableViewCell
        cell.set(content: tasks[indexPath.row])
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "detailsegue": let dest = segue.destination as?DetailViewController
        let selectedDetail = sender as! Task
        dest?.detailTask = selectedDetail
        dest?.transitioningDelegate = self
        dest?.interactor = interactor
            
        case "addsegue":
            let addVC = segue.destination as? AddNewViewController
            addVC?.transitioningDelegate = self
            addVC?.modalPresentationStyle = .custom
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedDetail = tasks[indexPath.row]
        
        performSegue(withIdentifier: "detailsegue", sender: selectedDetail)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let _ = presented as? DetailViewController else {
            transition.transitionMode = .present
            transition.startingPoint = addBtn.center
            transition.circleColor = addBtn.backgroundColor!
            
            return transition
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let _ = dismissed as? DetailViewController else {
            transition.transitionMode = .dismiss
            transition.startingPoint = addBtn.center
            transition.circleColor = addBtn.backgroundColor!
            
            return transition
        }
        return DismissAnimator()
    }
    
    @IBAction func menuTapped(_ sender: UIButton) {
        showMenu()
    }
    
    @IBAction func screenCoverTapped(_ sender: UIButton) {
        hideMenu()
    }
    
    func showMenu() {
        self.menuView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.menuView.alpha = 1
            self.screenCoverBtn.alpha = 1
            self.menuView.transform = .identity
        })
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.aboutButton.transform = .identity
        })
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.historyButton.transform = .identity
        })
        
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.menuView.alpha = 0
            self.screenCoverBtn.alpha = 0
            self.menuView.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        }) {
            success in self.menuView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.aboutButton.transform = CGAffineTransform(translationX: -self.aboutButton.frame.width, y: 0)
        })
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.historyButton.transform = CGAffineTransform(translationX: -self.historyButton.frame.width, y: 0)
        })
        
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    @IBAction func addNewButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "addsegue", sender: nil)
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .right
        view.addGestureRecognizer(gesture)
        gesture.addTarget(self, action: #selector(menuTapped(_:)))
        
    }
}


