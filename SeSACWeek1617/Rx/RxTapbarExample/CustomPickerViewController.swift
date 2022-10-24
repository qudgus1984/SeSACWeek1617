//
//  CustomPickerViewController.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CustomPickerViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just([[1, 2, 3], [5, 8, 13], [21, 34]])
            .bind(to: pickerView.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: disposeBag)

        pickerView.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print(models)
            })
            .disposed(by: disposeBag)
    }
}

final class PickerViewViewAdapter
    : NSObject
    , UIPickerViewDataSource
    , UIPickerViewDelegate
    , RxPickerViewDataSourceType
    , SectionedViewDataSourceType {
    typealias Element = [[CustomStringConvertible]]
    private var items: [[CustomStringConvertible]] = []

    func model(at indexPath: IndexPath) throws -> Any {
        items[indexPath.section][indexPath.row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = items[component][row].description
        label.textColor = UIColor.orange
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
        Binder(self) { (adapter, items) in
            adapter.items = items
            pickerView.reloadAllComponents()
        }.on(observedEvent)
    }
}


