//
//  HomeViewModel.swift
//  News App
//
//  Created by Gabriel Varela on 23/07/21.
//

import Foundation

protocol HomeViewModelDelegate {
    func loadDataDidFinish()
    func loadDataDidFinish(with error: String)
}

class HomeViewModel {
    
    private(set) var dataSource: NewsInformation? {
        didSet {
            delegate.loadDataDidFinish()
        }
    }
    
    private var delegate: HomeViewModelDelegate
    
    init(delegate: HomeViewModelDelegate){
        self.delegate = delegate
        self.loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        NetworkManager.shared.fetch(NewsInformation.self, endpoint: .topHeadlines) { result in
            switch result {
            case .success(let news):
                self.dataSource = news
            case .failure(let error):
                self.delegate.loadDataDidFinish(with: error.localizedDescription)
            }
        }
    }
    
}
