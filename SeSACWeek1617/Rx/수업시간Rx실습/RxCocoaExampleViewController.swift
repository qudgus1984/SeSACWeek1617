//
//  RxCocoaExampleViewController.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class RxCocoaExampleViewController: UIViewController {
    
    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var nickname = Observable.just("Jack")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickname
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.nickname.text = "Hello"
//        }
        
        
        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
    }
    
    //viewcontroller deinit이 되면, 알아서 disposed도 동작한다.
    deinit {
        print("RxCocoaViewController")
    }
    
    
    func setOperator() {
        let itemA = [3.3, 4.0, 5.0, 2.0, 3.7, 4.8]
        let itemB = [2.3, 4.0, 1.3]
        // Operator : Just 객체 1개만 가능
        Observable.just(itemA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")

            } onCompleted: {
                print("just - completed")
            } onDisposed: {
                print("just - disposed")
            }
            .disposed(by: disposeBag)
        
        // Operator : of - 객체 2개이상 가능
        Observable.of(itemA, itemB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")

            } onCompleted: {
                print("of - completed")
            } onDisposed: {
                print("of - disposed")
            }
            .disposed(by: disposeBag)
        
        // Operator : from
        Observable.from(itemA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")

            } onCompleted: {
                print("from - completed")
            } onDisposed: {
                print("from - disposed")
            }
            .disposed(by: disposeBag)
        
        //5번 반복
        //왜필요한가 -> 인터넷 통신 안될 때 5번 시도해보고 안되면 error로
        Observable.repeatElement("jack") // Infinite Observable Sequence
            .take(5) // Finite Observable Sequence
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")

            } onCompleted: {
                print("just - completed")
            } onDisposed: {
                print("just - disposed")
            }
            .disposed(by: disposeBag)
        
        // 1초가 지날때마다 계속 실행
        // deinit되지 않음.
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")

            } onCompleted: {
                print("interval - completed")
            } onDisposed: {
                print("interval - disposed")
            }
            .disposed(by: disposeBag)

        //DisposeBag: 리소스 해제 관리 -
        // 1. 시퀀스 끝날 때 but bind
        // 2. class deinit 자동 해재 (bind)
        // 3. dispose 직접 호출 -> dispose() 구독하는 것 마다 별도로 관리!
        // 4. DisposeBag을 새롭게 할당하거나, nil 전달
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.disposeBag = DisposeBag() //한번에 리소스 정리
//        }
        
        
    }
    
    func setSign() {
        //ex. 텍1(Observable), 텍2(Observable) > 레이블(Observer, bind)
        // orEmpty : 옵셔널 바인딩 자체로 해주는 메서드
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name: \(value1), email: \(value2)"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        /*
         // 데이터의 Stream이 변화한다 언제까지?! bind 전까지!
         signName     //UITextField
         .rx      //Reactive
         .text    //String?
         .orEmpty //String
         .map { $0.count } // Int
         .map { $0 < 4 } //Bool
         .bind(to: signEmail.rx.isHidden)
         .disposed(by: disposeBag)
         */
        
        signName.rx.text.orEmpty.map { $0.count < 4 }
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map{ $0.count > 4}
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.showAlert(title: "크크", message: "크크크", buttonTitle: "크크킄") { _ in
                    print("hi")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func showAlert(title: String, message: String, buttonTitle: String, buttonAction: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: buttonTitle, style: .default, handler: buttonAction)
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)

    }
    
    func setSwitch() {
        Observable.of(false) //just? of?
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        // 셀을 직접 만들어주기
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
        
        items
            .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        //        simpleTableView.rx.modelSelected(String.self)
        //            .subscribe { value in
        //                print(value)
        //            } onError: { error in
        //                print("error")
        //            } onCompleted: {
        //                print("completed")
        //            } onDisposed: {
        //                print("disposed")
        //            }
        //            .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        
    }
    
    func setPickerView() {
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])
        
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
        //            .subscribe(onNext: { value in
        //                print(value)
        //            })
            .disposed(by: disposeBag)
    }
    
    
}
