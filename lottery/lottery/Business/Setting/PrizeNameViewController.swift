//
//  PrizeNameViewController.swift
//  lottery
//
//  Created by chenzhen on 2018/8/31.
//  Copyright © 2018年 chenzhen. All rights reserved.
//

import UIKit

class PrizeNameViewController: BaseTableViewController {
    
    var dataArray: [MemberModel]?
    var updateCallBack:(() -> Void)? //闭包
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //右侧按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didAdd(sender:)))
        
        //列表
        self.tableView.tableFooterView = UIView()
        self.tableView.register(MembersCell.classForCoder(), forCellReuseIdentifier: "MembersCell")
        
        //查询数据
        self.dataArray = SqliteHelper.shared.selectMembers(selected: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataArray = self.dataArray {
            return dataArray.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembersCell", for: indexPath)
        
        if let dataArray = self.dataArray {
            let member = dataArray[indexPath.row]
            cell.textLabel?.text = member.name
            cell.accessoryType = member.selected == true ? .checkmark : .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
            //取出成员
            let member = self.dataArray![indexPath.row]
            
            //删除数据库
            SqliteHelper.shared.deleteMember(id: member.id)
            
            //闭包
            self.updateCallBack?()
            
            //删除数据源
            self.dataArray!.remove(at: indexPath.row)
            
            //删除UI
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        
        let update = UITableViewRowAction(style: .normal, title: "修改") { (action, indexPath) in
            let alertController = UIAlertController(title: nil, message: "修改成员", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let confirmAction  = UIAlertAction(title: "确认", style: .default) { (action: UIAlertAction) in
                if let textField = alertController.textFields?.first, let text = textField.text, text.isEmpty == false {
                    //更新数据源
                    let member = self.dataArray![indexPath.row]
                    member.name = text
                    
                    //更新数据库
                    SqliteHelper.shared.updateMember(id: member.id, name: member.name, selected: member.selected)
                    
                    //闭包
                    self.updateCallBack?()
                    
                    //刷新UI
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
            alertController.addTextField(configurationHandler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        return [delete, update]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let dataArray = self.dataArray else {
            return
        }
        
        let member = dataArray[indexPath.row]
        member.selected = !member.selected
        
        //更新数据源
        SqliteHelper.shared.updateMember(id: member.id, name: member.name, selected: member.selected)
        
        //闭包
        self.updateCallBack?()
        
        //更新UI
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = member.selected == true ? .checkmark : .none
    }
    
    /// 点击添加
    ///
    /// - Parameter sender: 按钮
    @objc private func didAdd(sender: UIButton) {
        guard let _ = self.dataArray else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: "添加成员", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirmAction  = UIAlertAction(title: "确认", style: .default) { (action: UIAlertAction) in
            if let textField = alertController.textFields?.first, let text = textField.text, text.isEmpty == false {
                let member = MemberModel()
                member.name = text
                member.selected = true
                member.id = SqliteHelper.shared.insertMember(name: text, selected: true)
                self.dataArray!.append(member)
                
                //闭包
                self.updateCallBack?()
                
                self.tableView.insertRows(at: [IndexPath(row: self.dataArray!.count - 1, section: 0)], with: .top)
            }
        }
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
