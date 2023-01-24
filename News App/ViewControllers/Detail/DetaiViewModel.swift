//
//  DetaiViewModel.swift
//  News App
//
//  Created by Premier on 19/07/21.
//

import Foundation

class DetailViewModel {
    
    private(set) var dataSource: Article
    
    init(dataSource: Article){
        self.dataSource = dataSource
    }
}
