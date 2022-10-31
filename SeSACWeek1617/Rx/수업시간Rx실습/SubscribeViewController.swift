//
//  SubscribeViewController.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/26.
//

import UIKit
import RxCocoa
import RxSwift
import RxAlamofire
import RxDataSources

class SubscribeViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>> (configureCell: { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
    })
    
    func textDataSource() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        Observable.just([
            SectionModel(model: "title1", items: [1, 2, 3]),
            SectionModel(model: "title2", items: [1, 2, 3]),
            SectionModel(model: "title3", items: [1, 2, 3])
             
                        ])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        

    }
    
    func testRxAlamofire() {
        //Success Error => <Single>
        let url = APIKey.searchURL + "apple"
        request(.get, url, headers: ["Authorization": APIKey.authorization])
            .data()
            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
            .subscribe(onNext: { value in
                print(value.results[0].likes)
            })
            .disposed(by: disposeBag)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        testRxAlamofire()
        textDataSource()
        
        
        
        
        Observable.of(1,2,3,4,5,6,7,8,9,10)
            .skip(3)
            .debug()
            .filter { $0 % 2 == 0 }
            .debug()
            .map { $0 * 2}
            .subscribe { value in
                print("===\(value)")
            }
            .disposed(by: disposeBag)
        
        
        
        
        
        // 1
        let sample = button.rx.tap
            sample
            .subscribe { [weak self] _ in
                self?.label.text = "안녕, 반가워"
            }
            .disposed(by: disposeBag)
        
        // 2
        button.rx.tap
            .withUnretained(self)
            .subscribe {  (vc, _) in
                vc.label.text = "안녕, 반가워"
            }
            .disposed(by: disposeBag)
        
        // 3. 네트워크 통신이나 파일 다운로드 중 백그라운드 작업
        button.rx.tap
            .observe(on: MainScheduler.instance) // 메인쓰레드에서 동작하도록 바꿔줌
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕, 반가워"
            }
            .disposed(by: disposeBag)
        
        // 4. bind <- 메인쓰레드에서만 동작!!!!! 만약 error나 complete가 발생한다면 runtime에러가 발생함!!
        button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.label.text = "안녕, 반가워"
            }
            .disposed(by: disposeBag)
        
        // 5. operator로 데이터의 stream 조작
        button.rx.tap
            .map { "안녕 반가워" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        // 6. driver traits: bind + stream 공유(리소스 낭비 빙지, share())
        button.rx.tap
            .map{ "안녕 반가워" }
            .asDriver(onErrorJustReturn: "ERROR")//다른 타입으로 변경 / ERROR날때 나타내 줄 문자열
        // label.rx.text.bind { [self weak] _ in self?.label.text = "안녕 반가워" }
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        
    }
}
