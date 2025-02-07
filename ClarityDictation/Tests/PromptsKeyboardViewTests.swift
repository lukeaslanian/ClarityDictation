import XCTest
import SwiftUI
@testable import ClarityDictation

class PromptsKeyboardViewTests: XCTestCase {
    var viewModel: DictateInputMethodService!
    var view: PromptsKeyboardView!
    
    override func setUp() {
        super.setUp()
        viewModel = DictateInputMethodService()
        view = PromptsKeyboardView(viewModel: viewModel)
    }
    
    override func tearDown() {
        viewModel = nil
        view = nil
        super.tearDown()
    }
    
    func testPromptsDisplay() throws {
        let view = PromptsKeyboardView(viewModel: DictateInputMethodService())
        #if os(iOS)
        let vc = UIHostingController(rootView: view)
        XCTAssertNotNil(vc.view)
        #else
        let vc = NSHostingController(rootView: view)
        XCTAssertNotNil(vc.view)
        #endif
    }
}
