//
//  ListTableViewCell.swift
//  Dedication App
//
//  Created by Franz on 10/10/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startdateLabel: UILabel!
    @IBOutlet weak var enddateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        viewShadow()
    }
    
    func set(content: Task) {
        
        self.titleLabel.text = content.title
        self.startdateLabel.text = content.startdate
//        self.enddateLabel.text = content.enddate
        self.descLabel.text = content.desc
        
    }
    
    func viewShadow() {
        bgView.layer.masksToBounds = false
        bgView.layer.shadowColor = UIColor.gray.cgColor
        bgView.layer.shadowOpacity = 1
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowRadius = 5
        
        bgView.layer.cornerRadius = 3
    }

}
