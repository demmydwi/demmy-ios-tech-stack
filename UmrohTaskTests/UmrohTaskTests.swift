//
//  UmrohTaskTests.swift
//  UmrohTaskTests
//
//  Created by Demmy Dwi Rhamadan on 15/01/20.
//  Copyright © 2020 Demmy Dwi Rhamadan. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest
@testable import UmrohTask

class UmrohTaskTests: XCTestCase {

    var viewModel: RepoVCViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        viewModel = RepoVCViewModel()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        
    }

    func testInitialState() throws {

        XCTAssertEqual(try viewModel.page.toBlocking().first(), 1)
        XCTAssertEqual(try viewModel.errMessage.toBlocking().first(), "")
        XCTAssertEqual(try viewModel.repoSections.toBlocking().first(), [])
        XCTAssertEqual(try viewModel.query.toBlocking().first(), "Rx")
        XCTAssertEqual(try viewModel.state.toBlocking().first(), RepoState.onLoading)
        XCTAssertEqual(try viewModel.isFinish.toBlocking().first(), false)
        
        XCTAssertEqual(viewModel.pageText, "Page 1")
        XCTAssertEqual(viewModel.totalRepoCountLabel, "No repository found")
        
    }
    

}
