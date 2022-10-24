//
//  RxNum.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class RxNumbersViewController: UIViewController {
    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number2: UITextField!
    @IBOutlet weak var number3: UITextField!

    let disposeBag = DisposeBag()

    @IBOutlet weak var result: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }
    

}
