//
//  SqliteHelper.swift
//  lottery
//
//  Created by chenzhen on 2018/7/6.
//  Copyright © 2018年 chenzhen. All rights reserved.
//

import Foundation
import SQLite

class SqliteHelper {
    //单例
    static let shared = SqliteHelper()
    private init() {}
    
    private let db = try! Connection("\(NSHomeDirectory())/Documents/db.sqlite3")
    
    /// 插入成员
    ///
    /// - Parameters:
    ///   - name: 名字
    ///   - selected: 是否选中
    func insertMember(name: String, selected: Bool) -> Int {
        let _members = Table("members")
        let _name = Expression<String>("name")
        let _selected = Expression<Bool>("selected")
        
        let insert = _members.insert(_name <- name, _selected <- selected)
        let id = try! self.db.run(insert)
        
        return Int(id)
    }
    
    /// 删除成员
    ///
    /// - Parameter id: id
    func deleteMember(id: Int) {
        let _members = Table("members")
        let _id = Expression<Int>("id")
        
        try! self.db.run(_members.filter(_id == id).delete())
    }
    
    /// 更新成员
    ///
    /// - Parameters:
    ///   - name: 昵称
    ///   - selected: 是否选中
    ///   - id: id
    func updateMember(id: Int, name: String, selected: Bool) {
        let _members = Table("members")
        let _id = Expression<Int>("id")
        let _name = Expression<String>("name")
        let _selected = Expression<Bool>("selected")
        
        try! self.db.run(_members.filter(_id == id).update(_name <- name, _selected <- selected))
    }
    
    /// 查询所有成员
    ///
    /// - Parameter selected: 选中状态
    /// - Returns: 成员数组
    func selectMembers(selected: Bool?) -> [MemberModel] {
        var _members = Table("members")
        let _id = Expression<Int>("id")
        let _name = Expression<String>("name")
        let _selected = Expression<Bool>("selected")
        
        if let selected = selected  {
            _members = _members.filter(_selected == selected)
        }
        
        var members = [MemberModel]()
        for object in try! self.db.prepare(_members) {
            let member = MemberModel()
            member.id = object[_id]
            member.name = object[_name]
            member.selected = object[_selected]
            
            members.append(member)
        }
        
        return members
    }
    
    /// 插入中奖者
    ///
    /// - Parameters:
    ///   - memberId: 成员id
    ///   - name: 昵称
    ///   - date: 中奖时间
    func insertWinner(memberId: Int, name: String, date: String) -> Int {
        let _winners = Table("winners")
        let _memberId = Expression<Int>("memberId")
        let _name = Expression<String>("name")
        let _date = Expression<String>("date")
        
        let insert = _winners.insert(_memberId <- memberId, _name <- name, _date <- date)
        let id = try! self.db.run(insert)
        
        return Int(id)
    }
    
    /// 删除中奖者
    ///
    /// - Parameter id: id
    func deleteWinner(id: Int) {
        let _winners = Table("winners")
        let _id = Expression<Int>("id")
        
        try! self.db.run(_winners.filter(_id == id).delete())
    }
    
    /// 查询所有中奖者
    ///
    /// - Returns: 中奖者数组
    func selectWinners() -> [WinnerModel] {
        let _winners = Table("winners")
        let _id = Expression<Int>("id")
        let _memberId = Expression<Int>("memberId")
        let _name = Expression<String>("name")
        let _date = Expression<String>("date")
        
        var winners = [WinnerModel]()
        
        for object in try! self.db.prepare(_winners) {
            let winner = WinnerModel()
            winner.id = object[_id]
            winner.memberId = object[_memberId]
            winner.name = object[_name]
            winner.date = object[_date]
            
            winners.append(winner)
        }
        
        return winners
    }
    
    /// 创建表
    func careteTables() {
        self.createMembers()
        self.createWinners()
    }
    
    /// 创建成员表
    private func createMembers() {
        do {
            try self.db.run("""
                CREATE TABLE IF NOT EXISTS "members" (
                    "id" integer PRIMARY KEY NOT NULL,
                    "name" text,
                    "selected" bool
                )
                """
            )
        } catch {
            print("创建成员表缓存表失败")
        }
    }
    
    /// 创建中奖表
    private func createWinners() {
        do {
            try self.db.run("""
                CREATE TABLE IF NOT EXISTS "winners" (
                    "id" integer PRIMARY KEY NOT NULL,
                    "memberId" integer,
                    "name" text,
                    "date" text
                )
                """
            )
        } catch {
            print("创建中奖表缓存表失败")
        }
    }
    
    
}
