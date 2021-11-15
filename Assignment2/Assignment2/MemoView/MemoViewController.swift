//
//  MemoViewController.swift
//  Assignment2
//
//  Created by 신상원 on 2021/11/08.
//

import UIKit
import MobileCoreServices
import RealmSwift

class MemoViewController: UIViewController {
    
    @IBOutlet weak var memoTextView: UITextView!
    
    var localRealm = try! Realm()
    var tasks: Results<UserMemo>!
    
    var memoTitle: String = ""
    var memoContent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rightBarButton 설정
        var rightButton: [UIBarButtonItem] = []
        rightButton.append(UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonClicked)))
        rightButton.append(UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked)))
        navigationItem.rightBarButtonItems = rightButton
        memoTextView.becomeFirstResponder()
    }
    
    //화면 사라질 경우 -> 저장
    //아무것도 입력하지 않은 경우(삭제) 필요
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    

    
    @objc
    func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func completeButtonClicked() {
        updateRealm()
        navigationController?.popViewController(animated: true)
    }
    
    
    //현재 텍스트뷰에 저장된 텍스트를 저장하도록 설정해보자!
    @objc
    func shareButtonClicked() {
      
    }

    
    func updateRealm() {
        let stringArray = memoTextView.text.components(separatedBy: "\n")
        
        if stringArray.count == 1 {
            print("아무것도 입력하지 않음")
            return
        }
        
        memoTitle = stringArray[0]
        for i in 1...stringArray.count - 1 {
            //엔터키로 인해서 라벨에 공백으로 나오지 않는 문제 존재
            memoContent += "\n"
            memoContent += "\(stringArray[i])"
        }
        
        //제목이 공백일 수도 있으니까
        if memoTitle == "" && memoContent == "" {
            print("아무것도 입력하지 않음")
            return
        }
        
        let task = UserMemo(memoTitle: memoTitle, memoDate: Date(), memoContent: memoContent)
        try! localRealm.write {
            localRealm.add(task)
        }
    }

}
