//
//  MemoListViewController.swift
//  Assignment2
//
//  Created by 신상원 on 2021/11/08.
//

import UIKit
import RealmSwift

class MemoListViewController: UIViewController {
    
    class FirstLaunch {
        let userDefaults: UserDefaults = .standard
        let wasLaunchedBefore: Bool
        var isFirstLaunch: Bool {
            return !wasLaunchedBefore
        }
        init() {
            let key = "com.any-suggestion.FirstLaunch.WasLaunchedBefore"
            let wasLaunchedBefore = userDefaults.bool(forKey: key)
            self.wasLaunchedBefore = wasLaunchedBefore
            if !wasLaunchedBefore { userDefaults.set(true, forKey: key) }
        }
    }
    let firstLaunch = FirstLaunch()
    
    @IBOutlet weak var tableView: UITableView!
    
    var localRealm = try! Realm()
    var memo: Results<UserMemo>!
    var pinMemo: Results<UserPinMemo>!

    var memoSearch: Results<UserMemo>!
    var pinMemoSearch: Results<UserPinMemo>!
    
    var filteredArr: [String] = []
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: MemoTableViewCell.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: MemoTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        //SearchController -> 공부 필요 일단 구현을 위해서 복사만 한 상태임!
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        self.navigationItem.searchController = searchController
        //self.navigationItem.title = "\(memo.count ?? 0  + pinMemo.count ?? 0) 개의 메모"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        print("Realm:",localRealm.configuration.fileURL!)
        memo = localRealm.objects(UserMemo.self).sorted(byKeyPath: "memoDate", ascending: false)
        pinMemo = localRealm.objects(UserPinMemo.self).sorted(byKeyPath: "memoDate", ascending: false)
        self.navigationItem.title = "\(memo.count + pinMemo.count) 개의 메모"
        
        memoSearch = localRealm.objects(UserMemo.self).sorted(byKeyPath: "memoDate", ascending: false).filter("memoDate == %@",Date())
        pinMemoSearch = localRealm.objects(UserPinMemo.self).sorted(byKeyPath: "memoDate", ascending: false).filter("memoDate == %@",Date())
        tableView.reloadData()
        
        if firstLaunch.isFirstLaunch {
            let sb = UIStoryboard(name: "Popup", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    //메모 생성
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Memo", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MemoViewController") as! MemoViewController
        
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.backButtonTitle = "메모"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "\(memo.count + pinMemo.count) 개의 메모"
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
      return searchController.isActive && !searchBarIsEmpty()
    }
    
    func dateCal(nowDate: Date) -> String {
        
        let date = DateFormatter()
        let releasedDate = Calendar.current.dateComponents([.weekOfYear, .day], from: nowDate)
        let nowDateCalendar = Calendar.current.dateComponents([.weekOfYear, .day], from: Date())
        date.locale = Locale(identifier: "ko_KR")
        
        //날짜가 같은 경우 시간만 나오도록 설정
        if releasedDate.day == nowDateCalendar.day {
            date.dateFormat = "a hh:mm"
        }
        //같은주일 경우에는 요일만 나오도록 설정
        else if releasedDate.weekOfYear == nowDateCalendar.weekOfYear {
            date.dateFormat = "EEEE"
        }
        //그외의 경우에는 모든 형식이 나오도록 설정
        else {
            date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
        }
        let nowDateForm = date.string(from: nowDate)
        
        return nowDateForm
    }
}

extension MemoListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //dump(searchController.searchBar.text)
        guard let text = searchController.searchBar.text else { return }
        let predicate = NSPredicate(format: "memoTitle CONTAINS[c] %@ OR memoContent CONTAINS[c]  %@",text as CVarArg,text as! CVarArg)
        //localRealm.objects(Memo.self).filter(predicate).sorted(byKeyPath: "memoDate", ascending: false)
        //memoSearch = memoSearch.filter("memoTitle CONTAINS[c] %@ OR memoContent CONTAINS[c] %@",text,text)
        self.memoSearch = memo.filter(predicate)
        self.pinMemoSearch = pinMemo.filter(predicate)
        //pinMemoSearch.filter("memoTitle CONTAINS[c] %@ OR memoContent CONTAINS[c] %@",text,text)
        
        
//        let sb = UIStoryboard(name: "Result", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "ResultTableViewController2") as! ResultTableViewController2
//        vc.findWord = text
//
//        if let resultsController = searchController.searchResultsController as?
//            ResultViewController {
//            resultsController.tableView.reloadData()
//            print("TableView Reload!!")
//            //print(vc.memo)
//            //print(vc.pinMemo)
//        }
//        print(memoSearch)
//        print(pinMemoSearch)
        tableView.reloadData()
    }
}

extension MemoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
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
            textlabel.font = .systemFont(ofSize: 20, weight: .bold)
            textlabel.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering() {
            if section == 0 {
                return "고정된 메모(검색)"
            }
            else {
                return "메모(검색)"
            }
        }
        
        else {
            if section == 0 {
                return "고정된 메모"
            }
            else {
                return "메모"
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            if section == 0 {
                return pinMemoSearch.count
            }
            else {
                return memoSearch.count
            }
        }
        
        else {
            if section == 0 {
                return pinMemo.count
            }
            else {
                return memo.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        
        
        
        if isFiltering() {
            if indexPath.section == 0 {
                let row = pinMemoSearch[indexPath.row]
                cell.memoContentLabel.text = row.memoContent?.replacingOccurrences(of: "\n", with: "")
                cell.memoTitleLabel.text = row.memoTitle
                
                cell.memoTitleLabel.highlight(searchText: searchController.searchBar.text!)
                cell.memoContentLabel.highlight(searchText: searchController.searchBar.text!)
                
                let date = DateFormatter()
                date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
                date.locale = Locale(identifier: "ko_KR")
                let nowDate = date.string(from: row.memoDate!)
                cell.memoDateLabel.text = nowDate
                return cell
            }
            
            else {
                let row = memoSearch[indexPath.row]
                cell.memoContentLabel.text = row.memoContent?.replacingOccurrences(of: "\n", with: "")
                cell.memoTitleLabel.text = row.memoTitle
                
                cell.memoTitleLabel.highlight(searchText: searchController.searchBar.text!)
                cell.memoContentLabel.highlight(searchText: searchController.searchBar.text!)
                
//                let date = DateFormatter()
//                date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
//                date.locale = Locale(identifier: "ko_KR")
//                let nowDate = date.string(from: row.memoDate!)
                
                cell.memoDateLabel.text = dateCal(nowDate: row.memoDate!)
                return cell
            }
        }
        
        
        else {
            if indexPath.section == 0 {
                //let row = tasks.filter("memoPin == true")[indexPath.row]
                let row = pinMemo[indexPath.row]
                cell.memoTitleLabel.text = row.memoTitle
                
                cell.memoTitleLabel.textColor = .white
                cell.memoContentLabel.textColor = .white
                
//                let date = DateFormatter()
//                date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
//                date.locale = Locale(identifier: "ko_KR")
//                let nowDate = date.string(from: row.memoDate!)
//                cell.memoDateLabel.text = nowDate
                cell.memoDateLabel.text = dateCal(nowDate: row.memoDate!)
                //cell.memoContentLabel.text = row.memoContent
                cell.memoContentLabel.text = row.memoContent?.replacingOccurrences(of: "\n", with: "")
                
                return cell
            }
            
            else {
                //let row = tasks.filter("memoPin == false")[indexPath.row]
                let row = memo[indexPath.row]
                cell.memoTitleLabel.text = row.memoTitle
                
                cell.memoTitleLabel.textColor = .white
                cell.memoContentLabel.textColor = .white
                
//                let date = DateFormatter()
//                date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
//                date.locale = Locale(identifier: "ko_KR")
//                let nowDate = date.string(from: row.memoDate!)
//                cell.memoDateLabel.text = nowDate
                cell.memoDateLabel.text = dateCal(nowDate: row.memoDate!)
                
                cell.memoContentLabel.text = row.memoContent?.replacingOccurrences(of: "\n", with: "")
                
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "ChangeMemo", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ChangeMemoViewController") as! ChangeMemoViewController
        
        //현재 시간을 기준으로 공유할 파일명을 설정
        let date = DateFormatter()
        date.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
        date.locale = Locale(identifier: "ko_KR")
        let nowDate = date.string(from: Date())
        vc.memoDate = nowDate
        
        //pin or not
        //row 값을 넘겨줘야 수정된걸 반영 해줄 수 있다.
        if self.isFiltering() {
            if indexPath.section == 0 {
                vc.memoTitle = pinMemoSearch[indexPath.row].memoTitle!
                vc.memoContent = pinMemoSearch[indexPath.row].memoContent!
                vc.isPin = true
                vc.row = indexPath.row
            }
            else {
                vc.memoTitle = memoSearch[indexPath.row].memoTitle!
                vc.memoContent = memoSearch[indexPath.row].memoContent!
                vc.isPin = false
                vc.row = indexPath.row
            }
        }
        else {
            if indexPath.section == 0 {
                vc.memoTitle = pinMemo[indexPath.row].memoTitle!
                vc.memoContent = pinMemo[indexPath.row].memoContent!
                vc.isPin = true
                vc.row = indexPath.row
            }
            else {
                vc.memoTitle = memo[indexPath.row].memoTitle!
                vc.memoContent = memo[indexPath.row].memoContent!
                vc.isPin = false
                vc.row = indexPath.row
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.backButtonTitle = "수정"
        
    }
    
    //제대로 정리하기
    //핀 고정
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinAction = UIContextualAction(style: .normal, title:  "고정", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let alert = UIAlertController(title: "메모를 고정", message: "메모를 고정(해제)하겠습니다.", preferredStyle: .alert)
            let pin = UIAlertAction(title: "확인", style: .default) { _ in
                print("메모 고정을 실행합니다.")
                //Pin 해제
                if self.isFiltering() {
                    if indexPath.section == 0 {
                        let row = self.pinMemoSearch[indexPath.row]
                        try! self.localRealm.write {
                            let task = UserMemo(memoTitle: row.memoTitle, memoDate: row.memoDate, memoContent: row.memoContent)
                            self.localRealm.add(task)
                            self.localRealm.delete(row)
                        }
                    }
                    //Pin 고정
                    else {
                        if self.pinMemo.count < 5 {
                            let row = self.memoSearch[indexPath.row]
                            try! self.localRealm.write {
                                let task = UserPinMemo(memoTitle: row.memoTitle, memoDate: row.memoDate, memoContent: row.memoContent)
                                self.localRealm.add(task)
                                self.localRealm.delete(row)
                            }
                        }
                        else {
                            self.fiveAlert()
                        }
                    }
                }
                
                else {
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
                        if self.pinMemo.count < 5 {
                            let row = self.memo[indexPath.row]
                            try! self.localRealm.write {
                                let task = UserPinMemo(memoTitle: row.memoTitle, memoDate: row.memoDate, memoContent: row.memoContent)
                                self.localRealm.add(task)
                                self.localRealm.delete(row)
                            }
                        }
                        else {
                            self.fiveAlert()
                        }
                    }
                }
                tableView.reloadData()
                
            }
            let cancle = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(pin)
            alert.addAction(cancle)
            
            self.present(alert, animated: true) {
                print("얼럿이 올라왔습니다")
            }
            success(true)
        })
        pinAction.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions:[pinAction])
    }
    
    //삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let alert = UIAlertController(title: "메모를 삭제", message: "메모를 삭제하겠습니다.", preferredStyle: .alert)
            let del = UIAlertAction(title: "확인", style: .default) { _ in
                print("메모 삭제를 실행합니다.")
                if self.isFiltering() {
                    if indexPath.section == 0 {
                        let row = self.pinMemoSearch[indexPath.row]
                        try! self.localRealm.write {
                            self.localRealm.delete(row)
                        }
                    }

                    else {
                        let row = self.memoSearch[indexPath.row]
                        try! self.localRealm.write {
                            self.localRealm.delete(row)
                        }
                    }
                }

                else {
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
                }

                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.navigationItem.title = "\(self.memo.count + self.pinMemo.count) 개의 메모"
                tableView.reloadData()
            }
            let cancle = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(del)
            alert.addAction(cancle)
            
            self.present(alert, animated: true) {
                print("얼럿이 올라왔습니다")
            }
            success(true)
        })
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
}
