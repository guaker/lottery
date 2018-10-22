//
//  SettingViewController.swift
//  lottery
//
//  Created by chenzhen on 2018/8/7.
//  Copyright © 2018年 chenzhen. All rights reserved.
//

import UIKit

class SettingViewController: BaseTableViewController {
    
    @IBOutlet weak var prizeNameLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    @IBOutlet weak var prizeNumLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //列表
        self.tableView.tableFooterView = UIView()
        self.tableView.register(MembersCell.classForCoder(), forCellReuseIdentifier: "MembersCell")
        
        //设置文本
        self.prizeNameLabel.text = ""
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let prizeNameVC = PrizeNameViewController.init(style: .plain)
            
            
        case 0:
            let membersVC = MembersViewController()
            membersVC.updateCallBack = {[weak self] in
//                self?.needUpdate = true
            }
            self.navigationController?.pushViewController(membersVC, animated: true)
        default:
            break
        }
    }
    
}
