//
//  IndexMemberLayout.swift
//  lottery
//
//  Created by chenzhen on 2018/8/1.
//  Copyright © 2018年 chenzhen. All rights reserved.
//

import UIKit

class IndexMemberLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        //遍历结果
        for i in 0..<layoutAttributes.count {
            let currentLayoutAttributes = layoutAttributes[i]
            let maximumSpacing: CGFloat = 8 //设置cell最大间距，需和最小间距相同
            
            if i > 0 {
                let prevLayoutAttributes = layoutAttributes[i - 1]
                let origin = prevLayoutAttributes.frame.maxX
                
                //判断是否在同一行
                if prevLayoutAttributes.frame.origin.y == currentLayoutAttributes.frame.origin.y {
                    currentLayoutAttributes.frame.origin.x = origin + maximumSpacing
                } else {
                    currentLayoutAttributes.frame.origin.x = maximumSpacing
                }
            } else {
                currentLayoutAttributes.frame.origin.x = maximumSpacing
            }
        }
        
        return layoutAttributes
    }
    
}
