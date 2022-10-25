//
//  DiffableRandomPhotoViewModel.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/24.
//

import Foundation

class DiffableRandomPhotoViewModel {
    
    var photoList: CObservable<RandomPhoto> = CObservable(RandomPhoto(likes: 0, downloads: 0,  user: [] ))
    
    func requestRandomhPhoto(query: String) {
        RandomAPIService.randomPhoto(query: query) { photo, statusCode, error in
            guard let photo = photo else { return }
            self.photoList.value = photo
            
        }
    }
}
