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
    var memoDate: String = ""
    var isPin: Bool = false //선택한 셀이 핀 셀인가 아닌가를 판별
    var row: Int = 0 // 선택한 셀이 몇번째 row 에 저장되어 있는가
    
    var localRealm = try! Realm()
    var memo: Results<UserMemo>!
    var pinMemo: Results<UserPinMemo>!
    
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
        
        memo = localRealm.objects(UserMemo.self).sorted(byKeyPath: "memoDate", ascending: false)
        pinMemo = localRealm.objects(UserPinMemo.self).sorted(byKeyPath: "memoDate", ascending: false)
    }
    
    //편집모드에서 데이터를 모두 지운 경우에 대한 예외처리 필요
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateRealm()
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
    
    @objc
    func shareButtonClicked() {
        saveFile(stringData: memoTextView.text, fileName: memoDate)
        presentActivityViewController()
        //navigationController?.popViewController(animated: true)
    }
    
    func saveFile(stringData: String, fileName: String) {
        let textFileName = fileName + ".txt"
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sampleFileName = directory.appendingPathComponent(textFileName)
        do {
            try stringData.write(to: sampleFileName, atomically: true, encoding: .utf8)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func documentDirectoryPath() -> String? {
            let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask //디렉토리내 제한걸어 준다고생각
            let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
            //path 는 배열형태, 0번째 인덱스에 url 이 저장된다
            
            if let directoryPath = path.first {
                return directoryPath
            }
            return nil
        }
    
    func presentActivityViewController() {
            //압축 파일 경로 가져오기
            let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("\(memoDate).txt")
            let fileURL = URL(fileURLWithPath: fileName)
            
            let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
            self.present(vc, animated: true, completion: nil)
        }
    
    //변경화면에서 Realm 데이터 업데이트
    func updateRealm() {
        let stringArray = memoTextView.text.components(separatedBy: "\n")

        if stringArray.count == 1 {
            print("아무것도 입력하지 않음")
            return
        }

        memoTitle = stringArray[0]
        memoContent = ""
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
        
        if isPin {
            let taskToUpdate = pinMemo[row]
            try! localRealm.write {
                taskToUpdate.memoTitle = memoTitle
                taskToUpdate.memoContent = memoContent
            }
        }
        else {
            let taskToUpdate = memo[row]
            try! localRealm.write {
                taskToUpdate.memoTitle = memoTitle
                taskToUpdate.memoContent = memoContent
            }
        }
    }
    

}
