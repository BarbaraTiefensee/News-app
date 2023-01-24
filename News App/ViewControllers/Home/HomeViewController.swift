//
//  HomeViewController.swift
//  News App
//
//  Created by Gabriel Varela on 15/07/21.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseID)
        tableView.rowHeight = 120
        return tableView
    }()
    
    private var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .dynamicColor(light: .blue1E234A, dark: .white)
        refresh.addTarget(self, action: #selector(refreshInformations(_:)), for: .valueChanged)
        return refresh
    }()
    
    lazy var viewModel = HomeViewModel(delegate: self)
    
    override func viewDidLoad() {
        self.showAlertSpinner()
        super.viewDidLoad()
        self.view.backgroundColor = .dynamicColor(light: .white, dark: .black)
        navigationController?.navigationBar.backgroundColor = .dynamicColor(light: .white, dark: .black)
        addTableView()
        addRefreshControll()
        self.removeAlertSpinner(delay: 1.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isTabBarHidden = false
        navigationItem.title = MessageType.articles.message
    }
}

//MARK: - Extension UIRefreshControl
extension HomeViewController {
    @objc private func refreshInformations(_ sender: Any) {
        self.viewModel.loadData()
    }
}

//MARK: - Layout
extension HomeViewController {
    private func addTableView() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(17)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-45)
        }
    }
    
    private func addRefreshControll() {
        tableView.addSubview(refreshControl)
    }
}

//MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func loadDataDidFinish(with error: String) {
        self.refreshControl.endRefreshing()
        self.showAlert(title: MessageType.error.message,
                       message: error,
                       doAction: UIAlertAction(title: MessageType.ok.message, style: .cancel, handler: { action in
                        let view = LoginViewController()
                        view.hidesBottomBarWhenPushed = true
                        view.navigationItem.hidesBackButton = true
                        self.navigationController?.pushViewController(view, animated: true)
                       }))
    }
    
    func loadDataDidFinish() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

//MARK: - TableView: Delegate and DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = viewModel.dataSource?.articles.count else { return 1}
        return data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseID, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        guard let cellInformations = viewModel.dataSource?.articles[indexPath.row] else {return UITableViewCell()}
        cell.setCell(news: cellInformations)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = viewModel.dataSource?.articles[indexPath.row] else { return }
        let detailViewController = DetailViewController(dataSource: article)
        detailViewController.tabBarController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
