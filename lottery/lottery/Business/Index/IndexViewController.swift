//
//  IndexViewController.swift
//  lottery
//
//  Created by chenzhen on 2018/6/1.
//  Copyright © 2018年 chenzhen. All rights reserved.
//

import UIKit

class IndexViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    private var startButton: UIButton!
    
    private var collectionView: UICollectionView!
    private var tableView: UITableView!
    
    private var timer: DispatchSourceTimer? //时间源
    
    private var memberArray: [MemberModel]? //抽奖数组
    private var winnerArray: [WinnerModel]? //中奖列表
    
    private var currentIndex: Int? //当前选中位置
    private var needUpdate: Bool? //需要刷新
    
    //颜色
    private var colorArray = [UIColor(red: 243/255.0, green: 139/255.0, blue: 115/255.0, alpha: 1.0),
                              UIColor(red: 38/255.0,  green: 227/255.0, blue: 149/255.0, alpha: 1.0),
                              UIColor(red: 243/255.0, green: 178/255.0, blue: 115/255.0, alpha: 1.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //右侧按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didSetting(sender:)))
        
        //表格
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: IndexMemberLayout())
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(IndexMemberCell.classForCoder(), forCellWithReuseIdentifier: "IndexMemberCell")
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        
        //分割线
        let middleLineView = UIView()
        middleLineView.backgroundColor = colorLine
        middleLineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(middleLineView)
        
        //列表
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.tableView.backgroundColor = .clear
        self.tableView.rowHeight = 44
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(IndexWinnerCell.classForCoder(), forCellReuseIdentifier: "IndexWinnerCell")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        
        //分割线
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = colorLine
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomLineView)
        
        //开始按钮
        self.startButton = UIButton(type: .system)
        self.startButton.setTitle("开始", for: .normal)
        self.startButton.setTitleColor(.white, for: .normal)
        self.startButton.setBackgroundImage(UIImage.init(named: "red_button_bg"), for: .normal)
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        self.startButton.addTarget(self, action: #selector(didStartLottery(sender:)), for: .touchUpInside)
        self.view.addSubview(self.startButton)
        
        //设置autoLayout
        let viewsDictionary: [String: UIView] = ["collectionView": self.collectionView,
                                                 "middleLineView": middleLineView,
                                                 "tableView": self.tableView,
                                                 "bottomLineView": bottomLineView,
                                                 "startButton": startButton]
        
        let metrics = ["bottom": bottomHeight]
        
        //横向约束 Horizontal
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[collectionView]|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
        
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[middleLineView]|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
        
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[tableView]|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
        
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[bottomLineView]|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
        
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-30-[startButton]-30-|",
                options: [],
                metrics: nil,
                views: viewsDictionary))
        
        //纵向约束 Vertical
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[collectionView][middleLineView(0.5)][tableView(220)][bottomLineView(0.5)]-8-[startButton(38)]-bottom-|",
                options: [],
                metrics: metrics,
                views: viewsDictionary))
        
        //数据
        self.memberArray = SqliteHelper.shared.selectMembers(selected: true)
        self.winnerArray = SqliteHelper.shared.selectWinners()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memberArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndexMemberCell", for: indexPath) as! IndexMemberCell
        cell.backgroundColor = self.colorArray[indexPath.row % self.colorArray.count]
        
        let member = self.memberArray![indexPath.row]
        cell.nameLabel.text = member.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let member = self.memberArray![indexPath.row]
        let nameWidth = member.name.size(font: font15pt).width
        
        let width = min(max(24, nameWidth + 11), screenWidth - 16)
        return CGSize(width: width, height: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let winnerArray = self.winnerArray  {
            return winnerArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndexWinnerCell") as! IndexWinnerCell
        
        if let winnerArray = self.winnerArray {
            let winner = winnerArray[indexPath.row]
            cell.dateLabel.text = winner.date
            cell.nameLabel.text = winner.name
        }
        
        return cell
    }
    
    /// 点击开始抽奖
    ///
    /// - Parameter sender: 按钮
    @objc func didStartLottery(sender: UIButton) {
        guard let memberArray = self.memberArray, memberArray.count > 0, let _ = self.winnerArray else {
            return
        }
        
        if sender.title(for: .normal) == "开始" {
            //开启定时器
            self.startTimer()
            
            sender.setTitle("停止", for: .normal)
            sender.setBackgroundImage(UIImage(named: "purple_button_bg"), for: .normal)
        } else {
            sender.setTitle("开始", for: .normal)
            sender.setBackgroundImage(UIImage(named: "red_button_bg"), for: .normal)
            
            //随机1秒之内停止
            let timeInterval = TimeInterval(arc4random() % 10) * 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                guard let index = self.currentIndex else {
                    return
                }
                
                //关闭定时器
                self.endTimer()
                
                //获取当前成员
                let member = memberArray[index]
                
                //插入数据库
                let winner = WinnerModel()
                winner.memberId = member.id
                winner.name = member.name
                winner.date = Date.string(Date())
                winner.id = SqliteHelper.shared.insertWinner(memberId: winner.memberId, name: winner.name, date: winner.date)
                
                //刷新数据源
                self.winnerArray!.insert(winner, at: 0)
                
                //刷新UI
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            }
        }
    }
    
    /// 开启定时器
    private func startTimer() {
        guard let memberArray = self.memberArray else {
            return
        }
        
        //创建全局队列
        let queue = DispatchQueue.global()
        
        // 在全局队列下创建一个时间源
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        
        // 设定这个时间源是0.2秒循环一次，立即开始
        self.timer?.schedule(deadline: .now(), repeating: 0.2)
        
        // 设定时间源的触发事件
        self.timer?.setEventHandler {
            //随机数
            let count = UInt32(memberArray.count)
            let index = Int(arc4random() % count)
            self.currentIndex = index
            
            //主线程刷新UI
            DispatchQueue.main.async {
                self.collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }
        }
        
        // 启动时间源
        self.timer?.resume()
    }
    
    /// 结束定时器
    private func endTimer() {
        self.timer?.cancel()
        self.timer = nil
    }
    
    /// 点击设置
    ///
    /// - Parameter sender: 按钮
    @objc private func didSetting(sender: UIButton) {
        let membersVC = MembersViewController()
        membersVC.updateCallBack = {[weak self] in
            self?.needUpdate = true
        }
        self.navigationController?.pushViewController(membersVC, animated: true)
    }
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //更新数据
        if self.needUpdate == true {
            self.memberArray = SqliteHelper.shared.selectMembers(selected: true)
            self.collectionView.reloadData()
        }
    }
    
}

