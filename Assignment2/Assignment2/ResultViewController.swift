//
//  ResultViewController.swift
//  Assignment2
//
//  Created by 신상원 on 2021/11/10.
//

import UIKit
import RealmSwift

class ResultViewController: UIViewController {
    
    var findWord: String = "1" {
        didSet {
            print("변경감지")
            print(findWord)
            memo = localRealm.objects(UserMemo.self).filter("memoTitle == %@",findWord)
            pinMemo = localRealm.objects(UserPinMemo.self).filter("memoTitle == %@",findWord)
            print(memo.count, pinMemo.count)
            //self.tableView.reloadData()
            self.tableView?.reloadData()
            
            
        }
    }
    
    var localRealm = try! Realm()
    var memo: Results<UserMemo>!
    var pinMemo: Results<UserPinMemo>!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: MemoTableViewCell.identifier, bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: MemoTableViewCell.identifier)
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        
        memo = localRealm.objects(UserMemo.self).sorted(byKeyPath: "memoDate", ascending: false)
        pinMemo = localRealm.objects(UserPinMemo.self).sorted(byKeyPath: "memoDate", ascending: false)
        //tableView.reloadData()
    }
    
//    self.memo = localRealm.objects(UserMemo.self).sorted(byKeyPath: "memoDate", ascending: false).filter("memoTitle == %@ OR memoContent == %@",findWord,findWord)
//    self.pinMemo = localRealm.objects(UserMemo.self).sorted(byKeyPath: "memoDate", ascending: false).filter("memoTitle == %@ OR memoContent == %@",findWord,findWord)
        
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pinMemo.count
        }
        else {
            return memo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            //if pinMemo.count != 0 {
                let row = pinMemo[indexPath.row]
                cell.memoContentLabel.text = row.memoContent
                cell.memoTitleLabel.text = row.memoTitle
                
                let date = DateFormatter()
                date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
                date.locale = Locale(identifier: "ko_KR")
                let nowDate = date.string(from: row.memoDate!)
                cell.memoDateLabel.text = nowDate
                return cell
            //}
        }
        
        else {
            //if memo.count != 0 {
                let row = memo[indexPath.row]
                cell.memoContentLabel.text = row.memoContent
                cell.memoTitleLabel.text = row.memoTitle
                
                let date = DateFormatter()
                date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
                date.locale = Locale(identifier: "ko_KR")
                let nowDate = date.string(from: row.memoDate!)
                cell.memoDateLabel.text = nowDate
                return cell
            //}
        }
        //return cell
    }
}
