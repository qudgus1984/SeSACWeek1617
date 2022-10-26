//
//  PracticeViewModel.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/26.
//

import Foundation
import RxSwift

enum error {
    case noImage
    case serverError
}

class PracticeViewModel {
    var photoList = PublishSubject<SearchPhoto>()
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { [weak self] photo, statusCode, error in
            
            guard let statusCode = statusCode, statusCode == 200 else {
                self?.photoList.onError(SearchError.serverError)
                return
            }
            
            guard let photo = photo else {
                self?.photoList.onError(SearchError.nophoto)
                return
            }
            self?.photoList.onNext(photo)
        }
    }
    
}
