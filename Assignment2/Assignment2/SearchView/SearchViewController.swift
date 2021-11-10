//
//  SearchViewController.swift
//  Assignment2
//
//  Created by 신상원 on 2021/11/08.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tavleView: UITableView!
    @IBOutlet weak var searchBar: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tavleView.delegate = self
        tavleView.dataSource = self
        searchBar.delegate = self
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.identifier) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.memoTitleLabel.text = "TEST"
        cell.memoTitleLabel.text = "just for TEST"
        cell.memoDateLabel.text = "2021.11.09"
        
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
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


