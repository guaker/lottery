//
//  MembersCell.swift
//  lottery
//
//  Created by chenzhen on 2018/6/5.
//  Copyright © 2018年 chenzhen. All rights reserved.
//

import UIKit

class MembersCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.textLabel?.font = font15pt
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
