//
//  ChageMemoViewController.swift
//  Assignment2
//
//  Created by 신상원 on 2021/11/09.
//

import UIKit
import RealmSwift

class ChangeMemoViewController: UIViewController {
    
    var memoTitle: String = ""
    var memoContent: String = ""
    
    var localRealm = try! Realm()
    var tasks: Results<UserMemo>!
    
    @IBOutlet weak var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rightBarButton 설정
        var rightButton: [UIBarButtonItem] = []
        rightButton.append(UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonClicked)))
        rightButton.append(UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked)))
        navigationItem.rightBarButtonItems = rightButton
        memoTextView.becomeFirstResponder()
        
        memoTextView.text += memoTitle
        memoTextView.text += memoContent
    }
    
    @objc
    func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func completeButtonClicked() {
        
        // 수정 사항을 어떻게 반영해 줄 것인가?
        
//        let stringArray = memoTextView.text.components(separatedBy: "\n")
//
//        if stringArray.count == 1 {
//            print("아무것도 입력하지 않음")
//            return
//        }
//
//        memoTitle = stringArray[0]
//        for i in 1...stringArray.count - 1 {
//            //엔터키로 인해서 라벨에 공백으로 나오지 않는 문제 존재
//            memoContent += "\n"
//            memoContent += "\(stringArray[i])"
//        }
//
//        //제목이 공백일 수도 있으니까
//        if memoTitle == "" && memoContent == "" {
//            print("아무것도 입력하지 않음")
//            return
//        }
        
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func shareButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    

}
