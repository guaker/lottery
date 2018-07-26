//
//  IndexWinnerCell.swift
//  lottery
//
//  Created by chenzhen on 2018/7/2.
//  Copyright © 2018年 chenzhen. All rights reserved.
//

import UIKit

class IndexWinnerCell: UITableViewCell {

    var dateLabel: UILabel! //时间
    var nameLabel: UILabel! //姓名
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        //时间
        self.dateLabel = UILabel()
        self.dateLabel.font = font16pt
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.dateLabel)
        
        //姓名
        self.nameLabel = UILabel()
        self.nameLabel.font = font16pt
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.nameLabel)
        
        //设置autoLayout
        let viewsDictionary: [String: UIView] = ["dateLabel": self.dateLabel,
                                                 "nameLabel": self.nameLabel]
        
        //横向约束 Horizontal
        self.contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-30-[dateLabel]-15-[nameLabel]->=30@750-|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
        
        //纵向约束 Vertical
        self.contentView.addConstraint(
            NSLayoutConstraint(
                item: self.dateLabel,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self.contentView,
                attribute: .centerY,
                multiplier: 1,
                constant: 0))
        
        self.contentView.addConstraint(
            NSLayoutConstraint(
                item: self.nameLabel,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self.contentView,
                attribute: .centerY,
                multiplier: 1,
                constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
