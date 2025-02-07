import XCTest
@testable import ClarityDictation

class DictateInputMethodServiceTests: XCTestCase {
    var service: DictateInputMethodService!

    override func setUp() {
        super.setUp()
        service = DictateInputMethodService()
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func testStartRecording() {
        service.startRecording()
        XCTAssertTrue(service.isRecording)
        XCTAssertFalse(service.isPaused)
        XCTAssertEqual(service.elapsedTime, 0)
    }

    func testStopRecording() {
        service.startRecording()
        service.stopRecording()
        XCTAssertFalse(service.isRecording)
        XCTAssertFalse(service.isPaused)
        XCTAssertNotNil(service.transcriptionResult)
    }

    func testPauseAndResumeRecording() {
        service.startRecording()
        service.pauseRecording()
        XCTAssertTrue(service.isPaused)
        service.resumeRecording()
        XCTAssertFalse(service.isPaused)
    }

    func testTranscribeAudio() {
        service.startRecording()
        service.stopRecording()
        XCTAssertNotNil(service.transcriptionResult)
        XCTAssertEqual(service.transcriptionResult, "Transcription result goes here")
    }
}
