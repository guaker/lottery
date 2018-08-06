//
//  IndexMemberCell.swift
//  lottery
//
//  Created by chenzhen on 2018/7/30.
//  Copyright © 2018年 chenzhen. All rights reserved.
//

import UIKit

class IndexMemberCell: UICollectionViewCell {
    //名字
    var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置属性
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        //选中背景
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = colorCellSelected
        
        //名字
        self.nameLabel = UILabel()
        self.nameLabel.font = font15pt
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.nameLabel)
        
        //设置autoLayout
        let viewsDictionary: [String: UIView] = ["nameLabel": self.nameLabel]
        
        //横向约束 Horizontal
        self.contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|->=5-[nameLabel]->=5-|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
        
        self.contentView.addConstraint(
            NSLayoutConstraint(
                item: self.nameLabel,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self.contentView,
                attribute: .centerX,
                multiplier: 1,
                constant: 0))
        
        //纵向约束
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
