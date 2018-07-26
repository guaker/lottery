//
//  Date+Category.swift
//  BoneForCustomer
//
//  Created by chenzhen on 2017/3/30.
//  Copyright © 2017年 YuanTe. All rights reserved.
//

import Foundation

extension Date {
    
    static func string(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: date)
    }
    
}
