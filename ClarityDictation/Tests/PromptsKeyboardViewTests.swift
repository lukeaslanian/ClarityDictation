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
    
    func testTranscriptionResultDisplayed() {
        viewModel.transcriptionResult = "Test transcription"
        let view = PromptsKeyboardView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        
        XCTAssertNotNil(hostingController.view)
        XCTAssertTrue(hostingController.view.subviews.contains { $0 is Text && ($0 as! Text).string == "Transcription: Test transcription" })
    }
}
