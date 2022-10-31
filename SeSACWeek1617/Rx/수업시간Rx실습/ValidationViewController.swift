//
//  ValidationViewController.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/27.
//

import UIKit
import RxSwift
import RxCocoa

class ValidationViewController: UIViewController {

    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    let disposeBag = DisposeBag()
    let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        observableVCSubject()

    }
    
    func bind() {
        
        /*
        nameTextField.rx.text //String?
            .orEmpty //String
            .map { $0.count >= 8 } //Bool
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        nameTextField.rx.text //String?
            .orEmpty //String
            .map { $0.count >= 8 }
            .bind { value in
                let color: UIColor = value ? .systemYellow : .lightGray
                self.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
         */

        viewModel.validText
            .asDriver(onErrorJustReturn: "ERROR")
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = nameTextField.rx.text //String?
            .orEmpty //String
            .map { $0.count >= 8 }

        validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)

        validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemYellow : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)

        stepButton.rx.tap
            .bind { _ in
                print("SHOW ALERT")
            }
            .disposed(by: disposeBag)

//        let testA = stepButton.rx.tap
//            .map { "안녕하세요" }
//            .asDriver(onErrorJustReturn: "ERROR")
////            .share()
//
//        testA
//            .drive(validationLabel.rx.text)
//            .disposed(by: disposeBag)
//
//
//        testA
//            .drive(nameTextField.rx.text)
//            .disposed(by: disposeBag)
//
//        testA
//            .drive(stepButton.rx.title())
//            .disposed(by: disposeBag)
//
//
//
//        //Stream, Sequence
//        stepButton.rx.tap
//            .subscribe { _ in
//                print("next")
//            } onError: { error in
//                print("error")
//            } onCompleted: {
//                print("complete")
//            } onDisposed: {
//                print("dispose")
//            }
//            .disposed(by: disposeBag)
        
            //.disposed(by: DisposeBag()) // ?? viewDidLoad시점에 dispose 리소스 정리, deinit, error / complete를 만나면 dispose 실행
        //

    }
    
    func observableVCSubject() {
        //just of from
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }

        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)

        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)

        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
//

        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))

        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)

        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)

        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
    }

    
}
