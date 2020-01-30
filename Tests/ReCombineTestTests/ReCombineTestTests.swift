import Combine
import XCTest
@testable import ReCombineTest

final class ReCombineTestTests: XCTestCase {
    var cancellable: AnyCancellable?
    
    // MARK: - Test MockStore's dispatched action tracking
    
    func testMockStore_DispatchedNoopActionCaptured() {
        let mockStore = MockStore(state: CounterState())
        let _ = CounterViewModel(store: mockStore)
        let expectationReceiveAction = expectation(description: "receiveAction")
        cancellable = mockStore.actionSubject.sink(receiveValue: { action in
            XCTAssertTrue(action is NoopAction)
            expectationReceiveAction.fulfill()
        })
        
        wait(for: [expectationReceiveAction], timeout: 10.0)
    }
    
    func testMockStore_DispatchedIncrementActionCaptured() {
        let mockStore = MockStore(state: CounterState())
        let vm = CounterViewModel(store: mockStore)
        vm.incrementTapped()
        let expectationReceiveAction = expectation(description: "receiveAction")
        cancellable = mockStore.actionSubject.sink(receiveValue: { action in
            XCTAssertTrue(action is Increment)
            expectationReceiveAction.fulfill()
        })
        
        wait(for: [expectationReceiveAction], timeout: 10.0)
    }
    
    // MARK: - Test MockStore's init and setState update selectors
    
    func testMockStore_InitState_CountStringSelects() {
        let mockStore = MockStore(state: CounterState(count: 2))
        let vm = CounterViewModel(store: mockStore)
        let expectationCountStringUpdates = expectation(description: "countStringUpdates")
        cancellable = vm.$countString.sink(receiveValue: { countString in
            XCTAssertEqual("Current Count: 2", countString)
            expectationCountStringUpdates.fulfill()
        })
        
        wait(for: [expectationCountStringUpdates], timeout: 10.0)
    }
    
    func testMockStore_SetState_UpdatesCountString() {
        let mockStore = MockStore(state: CounterState(count: 2))
        let vm = CounterViewModel(store: mockStore)
        mockStore.setState(CounterState(count: -5))
        let expectationCountStringUpdates = expectation(description: "countStringUpdates")
        cancellable = vm.$countString.sink(receiveValue: { countString in
            XCTAssertEqual("Current Count: -5", countString)
            expectationCountStringUpdates.fulfill()
        })
        
        wait(for: [expectationCountStringUpdates], timeout: 10.0)
    }
    
    // MARK: - Test MockStore dispatch 

    static var allTests = [
        ("testMockStore_DispatchedNoopActionCaptured", testMockStore_DispatchedNoopActionCaptured),
        ("testMockStore_DispatchedIncrementActionCaptured", testMockStore_DispatchedIncrementActionCaptured),
        ("testMockStore_InitState_CountStringSelects", testMockStore_InitState_CountStringSelects),
        ("testMockStore_SetState_UpdatesCountString", testMockStore_SetState_UpdatesCountString)
    ]
}
