//
//  ViewController.swift
//  UmrohTask
//
//  Created by Demmy Dwi Rhamadan on 15/01/20.
//  Copyright © 2020 Demmy Dwi Rhamadan. All rights reserved.
//

import UIKit
import Moya
import RxCocoa
import RxSwift
import RxDataSources
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var totalResult: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel = RepoVCViewModel()
    let disposeBag = DisposeBag()
    
}

extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        setupRx()
        viewModel.requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension ViewController {
    
    func keyboardHeight() -> Observable<CGFloat> {
        return Observable.from([
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                            .map { notification -> CGFloat in
                                (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 },
                NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                            .map { _ -> CGFloat in 0 }
                ]).merge()
    }
    
    func share(repo: RepoModel){
        let repoName = repo.name ?? "-"
        let repoUrl = repo.url ?? "-"
        let textToShare = [ repoName, repoUrl ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}

//MARK: - Rx Setup
extension ViewController {
    
    func setupRx(){
        handlingBlockingKeyboard()
        setupTotalResult()
        setupSearchBar()
        setupTableView()
    }
    
    func handlingBlockingKeyboard(){
        keyboardHeight()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { (keyboardHeight)  in
            self.tableView.contentInset.bottom = keyboardHeight
        }).disposed(by: disposeBag)
    }
    
    func setupTotalResult(){
        viewModel.repoSections.subscribe(onNext: { (_repoSections) in
            self.totalResult.text = self.viewModel.totalRepoCountLabel
        })
    }
    
    func setupSearchBar(){
        searchBar.rx.text.changed.asSignal().debounce(.milliseconds(500))
            .asObservable().subscribe(onNext: { (searchText) in
                self.viewModel.refresh(withQuery: searchText ?? "")
        }).disposed(by: disposeBag)
    }
    
    func setupTableView(){
        
        let dataSource = RxTableViewSectionedReloadDataSource<RepoModelSectioned>(configureCell: { _, tv, ip, repo in
            let cell = tv.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryCell
            cell.btnShare.rx.tap.bind{
                self.share(repo: repo)
            }.disposed(by: self.disposeBag)
            cell.configureWith(repoModel: repo, searchText: self.viewModel.query.value)
            return cell
        }, titleForHeaderInSection: { ds, section -> String? in
            return ds[section].header
        })
        
        viewModel.repoSections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RepoModel.self)
                   .subscribe(onNext: { repo in
            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
              self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
            UIApplication.shared.openURL(URL(string: repo.htmlURL!)!)
        }).disposed(by: disposeBag)
        
        tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.refresh()
                self.searchBar.text = ""
        }).disposed(by: disposeBag)
        
        tableView.rx.contentOffset.asObservable().map { (_) in
                self.tableView.isNearBottomEdge(edgeOffset: 40)
        }.distinctUntilChanged()
        .subscribe(onNext: { (isNear) in
            if (isNear && self.viewModel.state.value != .onLoading && !self.viewModel.isFinish.value) {
                self.viewModel.requestData()
            }
        }).disposed(by: disposeBag)
        
        viewModel.state.subscribe(onNext: { (_state) in
            switch(_state) {
            case .onLoaded:
                self.tableView.refreshControl?.endRefreshing()
            case .onLoading:
                self.tableView.refreshControl?.beginRefreshing()
                self.tableView.restore()
            case .onError, .onEmpty:
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.setEmptyOrErrorMessage(errorMessage: self.viewModel.errMessage.value)
            }
        }).disposed(by: disposeBag)
    }

}

