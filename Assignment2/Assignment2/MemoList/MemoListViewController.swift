//
//  MemoListViewController.swift
//  Assignment2
//
//  Created by 신상원 on 2021/11/08.
//

import UIKit
import RealmSwift

class MemoListViewController: UIViewController {
    
    //TEST용 나중에 지우기
    var numberOfPin: Int = 2
    var numberOfMemo: Int = 8
    
    @IBOutlet weak var tableView: UITableView!
    
    var localRealm = try! Realm()
    var memo: Results<UserMemo>!
    var pinMemo: Results<UserPinMemo>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: MemoTableViewCell.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: MemoTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        //tableView.style = .insetGrouped
        
        //SearchController -> 공부 필요 일단 구현을 위해서 복사만 한 상태임!
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false // SearchBar 가 활성화 되면 Navigation title 이 사라짐
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true // Large title로 하고싶을 때 추가
        self.navigationItem.hidesSearchBarWhenScrolling = false // 스크롤할떄도 searchBar 가 사라지지 않도록 설정
        
        print("Realm:",localRealm.configuration.fileURL!)
        memo = localRealm.objects(UserMemo.self).sorted(byKeyPath: "memoDate", ascending: false)
        pinMemo = localRealm.objects(UserPinMemo.self).sorted(byKeyPath: "memoDate", ascending: false)
    }
    
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        
        //print("Bar Button Clicked")
        let sb = UIStoryboard(name: "Memo", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MemoViewController") as! MemoViewController
        
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.backButtonTitle = "메모"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}


extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //section header 의 높이를 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //Section Header 글자 크기 변경
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let header = view as! UITableViewHeaderFooterView

        if let textlabel = header.textLabel {
            //textlabel.font = textlabel.font.withSize(20)
            textlabel.font = .systemFont(ofSize: 20, weight: .bold)
            textlabel.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "고정된 메모"
        }
        else {
            return "메모"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //return tasks.filter("memoPin == true").count
            return pinMemo.count
        }
        else {
            //return tasks.filter("memoPin == false").count
            return memo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier) as? MemoTableViewCell else {
                return UITableViewCell()
            }
            
            //let row = tasks.filter("memoPin == true")[indexPath.row]
            let row = pinMemo[indexPath.row]
            cell.memoTitleLabel.text = row.memoTitle
            
            let date = DateFormatter()
            date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
            date.locale = Locale(identifier: "ko_KR")
            let nowDate = date.string(from: row.memoDate!)
            cell.memoDateLabel.text = nowDate
            cell.memoContentLabel.text = row.memoContent
            
            return cell
        }
        
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier) as? MemoTableViewCell else {
                return UITableViewCell()
            }
            
            //let row = tasks.filter("memoPin == false")[indexPath.row]
            let row = memo[indexPath.row]
            cell.memoTitleLabel.text = row.memoTitle
            
            let date = DateFormatter()
            date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
            date.locale = Locale(identifier: "ko_KR")
            let nowDate = date.string(from: row.memoDate!)
            cell.memoDateLabel.text = nowDate
            
            cell.memoContentLabel.text = row.memoContent?.replacingOccurrences(of: "\n", with: "")
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "ChangeMemo", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ChangeMemoViewController") as! ChangeMemoViewController
        
        //pin or not
        //row 값을 넘겨줘야 수정된걸 반영 해줄 수 있다.
        
        if indexPath.section == 0 {
            vc.memoTitle = pinMemo[indexPath.row].memoTitle!
            vc.memoContent = pinMemo[indexPath.row].memoContent!
        }
        else {
            vc.memoTitle = memo[indexPath.row].memoTitle!
            vc.memoContent = memo[indexPath.row].memoContent!
        }
        
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.backButtonTitle = "수정"
        
    }
    
    //제대로 정리하기
    //핀 고정
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinAction = UIContextualAction(style: .normal, title:  "고정", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //Pin 해제
            if indexPath.section == 0 {
                let row = self.pinMemo[indexPath.row]
                try! self.localRealm.write {
                    let task = UserMemo(memoTitle: row.memoTitle, memoDate: row.memoDate, memoContent: row.memoContent)
                    self.localRealm.add(task)
                    self.localRealm.delete(row)
                }
            }
            //Pin 고정
            else {
                let row = self.memo[indexPath.row]
                try! self.localRealm.write {
                    let task = UserPinMemo(memoTitle: row.memoTitle, memoDate: row.memoDate, memoContent: row.memoContent)
                    self.localRealm.add(task)
                    self.localRealm.delete(row)
                }
            }
            tableView.reloadData()
            success(true)
        })
        pinAction.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions:[pinAction])
    }
    
    //삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            if indexPath.section == 0 {
                let row = self.pinMemo[indexPath.row]
                try! self.localRealm.write {
                    self.localRealm.delete(row)
                }
            }
            
            else {
                let row = self.memo[indexPath.row]
                try! self.localRealm.write {
                    self.localRealm.delete(row)
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            success(true)
        })
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
    
}

extension MemoListViewController: UISearchBarDelegate {
    
    // 검색 버튼(키보드 리턴키) 눌렀을 때 실행
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            print(#function)
        }
        
        //취소버튼 눌렀을 때 실행
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            print(#function)
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        //서치바에서 커서 깜빡이기 시작할 때
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            print(#function)
            searchBar.setShowsCancelButton(true, animated: true)
        }
}
