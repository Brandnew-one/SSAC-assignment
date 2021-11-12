//
//  Alert+Extension.swift
//  Assignment2
//
//  Created by 신상원 on 2021/11/12.
//

import Foundation
import UIKit

// 1) 메모를 삭제 하시겠습니까? -> Y/N
// 2) 메모를 고정 하시겠습니까? -> Y/N
// 3) 고정을 5개까지만 가능합니다

extension UIViewController {
    
    func deleteAlert(delAction: @escaping () -> ()) {
        let alert = UIAlertController(title: "메모를 삭제", message: "메모를 삭제하겠습니다.", preferredStyle: .alert)
        let del = UIAlertAction(title: "확인", style: .default) { _ in
            print("메모 삭제를 실행합니다.")
            delAction()
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(del)
        alert.addAction(cancle)
        
        self.present(alert, animated: true) {
            print("얼럿이 올라왔습니다")
        }
    }
    
    func pinAlert(pinAction: @escaping () -> ()) {
        let alert = UIAlertController(title: "메모를 고정", message: "메모를 고정하겠습니다.", preferredStyle: .alert)
        let pin = UIAlertAction(title: "확인", style: .default) { _ in
            print("메모 고정을 실행합니다.")
            pinAction()
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(pin)
        alert.addAction(cancle)
        
        self.present(alert, animated: true) {
            print("얼럿이 올라왔습니다")
        }
    }
    
    func fiveAlert() {
        let alert = UIAlertController(title: "고정 메모 제한", message: "고정 메모는 5개 까지만 가능합니다.", preferredStyle: .alert)
        
        let cancle = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(cancle)
        
        self.present(alert, animated: true) {
            print("얼럿이 올라왔습니다")
        }
    }
    
    
}
