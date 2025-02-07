import SwiftUI

@main
struct ClarityDictationApp: App {
    init() {
        // Set up default UserDefaults values
        let defaults: [String: Any] = [
            "vibrationEnabled": true,
            "audioFocusEnabled": true,
            "inputLanguagesString": "en",
            "currentInputLanguagePos": 0,
            "overlayCharacters": "()-:!?,.",
            "instantOutput": false,
            "outputSpeed": 5,
            "stylePromptSelection": 1,
            "stylePromptCustomText": "",
            "resendButton": false,
            "instantRecording": false,
            "postProcessingEnabled": true
        ]
        UserDefaults.standard.register(defaults: defaults)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
