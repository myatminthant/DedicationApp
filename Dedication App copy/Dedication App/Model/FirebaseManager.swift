//
//  FirebaseManager.swift
//  Dedication App
//
//  Created by Franz on 10/18/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation

import Firebase


class FirebaseManager {
    
    let dbRef = Database.database().reference()
    static var share = FirebaseManager()
    
    var userid = Auth.auth().currentUser?.uid ?? ""
    
    func createNewTask( _ task:Task){
       
        let taskRef = dbRef.child("Tasks").child(userid).childByAutoId()
         task.id = taskRef.key ?? ""
        taskRef.setValue(["id": taskRef.key ?? task.id ,"title":task.title, "startdate":task.startdate, "enddate":task.enddate,"desc":task.desc])
        
    }
    func updateTask( _ task:Task){
        
        let taskRef = dbRef.child("Tasks").child(userid).child(task.id)
        task.id = taskRef.key ?? ""
        taskRef.setValue(["id": taskRef.key ?? task.id ,"title":task.title, "startdate":task.startdate, "enddate":task.enddate,"desc":task.desc])
        
    }
    
    func deleteTask(_ task:Task){
        
        let taskRef  = dbRef.child("Tasks").child(userid).child(task.id)
        taskRef.removeValue()
    }
    
    func observeTask(_ callback: @escaping ([Task])->())  {
        
        dbRef.child("Tasks").child(userid).observe(.value) { (snapshot) in
            //print(snapshot)
            var tasks = [Task]()
            let dictTask = snapshot.value as? [String: Any] ?? [:]
            //print(dictTask)
            
            for key in Array(dictTask.keys) {
                let task = Task(dictionary: dictTask[key] as! [String : Any], key: key)
                
                 tasks.append(task)
                
            }
         callback(tasks)
        }
    }
}
