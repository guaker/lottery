//
//  String+Category.swift
//  BoneForCustomer
//
//  Created by chenzhen on 2017/3/30.
//  Copyright © 2017年 YuanTe. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /// 单行文本size
    ///
    /// - Parameter font: 字体
    /// - Returns: size
    func size(font: UIFont) -> CGSize {
        let string = NSString(string: self)
        
        let rect = string.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                                       options: .usesLineFragmentOrigin,
                                       attributes: [NSAttributedStringKey.font: font],
                                       context: nil)
        
        return rect.size
    }
    
}
