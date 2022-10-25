//
//  NewsViewModel.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/20.
//

import Foundation
import RxCocoa
import RxSwift

class NewsViewModel {
    
    var list: BehaviorSubject<[News.NewsItem]> = BehaviorSubject(value: News.items)
    
    var RxPageNumber: BehaviorSubject<String> = BehaviorSubject(value: "3000")
    
    var pageNumber: CObservable<String> = CObservable("3000")
    
    var sample: CObservable<[News.NewsItem]> = CObservable(News.items)
    
    func changePageNumberFormat(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(for: number)!
        
        pageNumber.value = result
    }
    
    func RxChangePageNumberFormat(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(for: number)!
        
        pageNumber.value = result
    }
    
    func resetSample() {
        sample.value = []
    }
    
    func resetRxSample() {
        list.onNext([])
    }
    
    func loadSample() {
        sample.value = News.items
    }
    
    func loadRxSample() {
        list.onNext(News.items)
    }
    
}
