//
//  RepoViewModel.swift
//  UmrohTask
//
//  Created by Demmy Dwi Rhamadan on 15/01/20.
//  Copyright © 2020 Demmy Dwi Rhamadan. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

enum RepoState {
    case onLoading
    case onLoaded
    case onError
    case onEmpty
}

public class RepoVCViewModel {
    
    let repoSections: BehaviorRelay<[RepoModelSectioned]> = BehaviorRelay(value: [])
    
    var totalRepoCountLabel: String {
        get {
            let isEmpty = repoSections.value.isEmpty
            if isEmpty {
                return "No repository found"
            }
            
            let count = repoSections.value.map({ _item in _item.count }).reduce(0){ x, y in x + y }
            return "Found \(count - 1) \(count == 1 ? "repository" : "repositories")"
        }
    }
    
    var pageText: String {
        get {
            return "Page \(page.value)"
        }
    }
    
    let state: BehaviorRelay<RepoState> = BehaviorRelay(value: .onLoading)
    let isFinish: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let query: BehaviorRelay<String> = BehaviorRelay(value: "Rx")
    let errMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    let page: BehaviorRelay<Int> = BehaviorRelay(value: 1)
    private let disposable = DisposeBag()
    
}

extension RepoVCViewModel {
    
    public func requestData(completion: (() -> Void)? = nil){
        let provider = MoyaProvider<GitHub>()
        provider.request(.repository(query: query.value, page: page.value)) { (result) in
            completion?() 
            switch (result) {
            case let .success(response):
                self.onSuccess(data: response.data)
            case let .failure(error):
                self.onError(errorMessage: error.localizedDescription)
            }
        }
    }
    
    public func refresh(withQuery: String = "Rx"){
        var q = withQuery
        if q.isEmpty {
            q = "Rx"
        }
        isFinish.accept(false)
        page.accept(1)
        errMessage.accept("")
        query.accept(q)
        state.accept(.onLoading)
        repoSections.accept([])
        requestData()
    }
    
}

extension RepoVCViewModel {
    
    private func onSuccess(data: Data){
        let decoder = JSONDecoder()
        do {
            let repoResponse = try decoder.decode(RepoResponse.self, from: data)
            if (page.value == 1) {
                if (repoResponse.items.isEmpty) {
                    onInitEmptyResult()
                } else {
                    onInitResult(repoResponse)
                }
            } else {
                if (repoResponse.items.isEmpty) {
                    onLoadMoreEmptyResult()
                } else {
                    onLoadMoreResult(repoResponse)
                }
            }
        } catch let error {
            onError(errorMessage: error.localizedDescription)
        }
    }
    
    private func onError(errorMessage: String){
        self.repoSections.accept([])
        self.errMessage.accept(errorMessage)
        if (page.value == 1) {
            self.state.accept(.onError)
        } else {
            
        }
    }
    
    private func onInitEmptyResult(){
        self.state.accept(.onEmpty)
    }
    
    private func onInitResult(_ repoResponse: RepoResponse){
        print(repoResponse.items.count)
        var _items = repoResponse.items
        let loadingModel = RepoModel.loadingView()
        _items.append(loadingModel)
        let rms = RepoModelSectioned.copyWith(pageText, _items)
        self.repoSections.accept([rms])
        self.state.accept(.onLoaded)
        self.page.accept(self.page.value + 1)
    }
    
    private func onLoadMoreEmptyResult(){
        var _lastRepo = repoSections.value.last!
        
        var lastItem = _lastRepo.data.last!
        lastItem.isLoadingView = false
        _lastRepo.data.removeLast()
        _lastRepo.data.append(lastItem)
        
        self.repoSections.accept(repoSections.value.dropLast() + [_lastRepo])
        self.isFinish.accept(true)
        self.state.accept(.onLoaded)
    }
    
    private func onLoadMoreResult(_ repoResponse: RepoResponse){
        var _lastRepo = repoSections.value.last!
        _lastRepo.data = _lastRepo.data.filter({ (model) in
                   model.isLoadingView == nil
        })
        let _oldRepo: [RepoModelSectioned] = repoSections.value.dropLast()
        
        let _repoSections: [RepoModelSectioned] = _oldRepo + [_lastRepo]
        
        let loadingModel = RepoModel.loadingView()
        let _items = repoResponse.items + [loadingModel]
        
        let rms = RepoModelSectioned.copyWith(pageText, _items)
        self.repoSections.accept(_repoSections + [rms])
        
        page.accept(self.page.value + 1)
        
        
    }
    
}
