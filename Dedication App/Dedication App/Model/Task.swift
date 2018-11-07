//
//  Tasks.swift
//  Dedication App
//
//  Created by Franz on 10/17/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation

class Task {
    
    var id:String
    var title:String
    var startdate:String
    var enddate:String
    var desc: String
    
    init(dictionary: [String: Any], key: String  = "") {
        self.id = key
        self.title = dictionary["title"] as! String
        self.startdate = dictionary["startdate"] as! String
        self.enddate = dictionary["enddate"] as! String
        self.desc = dictionary["desc"] as! String

    }
}
