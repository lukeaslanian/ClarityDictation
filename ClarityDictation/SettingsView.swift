import SwiftUI

struct SettingsView: View {
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true
    @AppStorage("audioFocusEnabled") private var audioFocusEnabled = true
    @AppStorage("inputLanguages") private var inputLanguages: Set<String> = ["en"]
    @AppStorage("currentInputLanguagePos") private var currentInputLanguagePos = 0
    @AppStorage("overlayCharacters") private var overlayCharacters = "()-:!?,."
    @AppStorage("instantOutput") private var instantOutput = false
    @AppStorage("outputSpeed") private var outputSpeed = 5
    @AppStorage("apiKey") private var apiKey = UserDefaults.standard.string(forKey: "apiKey") ?? ""
    @AppStorage("customApiHost") private var customApiHost = ""
    @AppStorage("customApiHostEnabled") private var customApiHostEnabled = false
    @AppStorage("stylePromptSelection") private var stylePromptSelection = 1
    @AppStorage("stylePromptCustomText") private var stylePromptCustomText = ""
    @AppStorage("resendButton") private var resendButton = false
    @AppStorage("instantRecording") private var instantRecording = false
    @AppStorage("postProcessingEnabled") private var postProcessingEnabled = true

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Vibration Enabled", isOn: $vibrationEnabled)
                    Toggle("Audio Focus Enabled", isOn: $audioFocusEnabled)
                }

                Section(header: Text("Input Languages")) {
                    ForEach(Array(inputLanguages), id: \.self) { language in
                        Text(language)
                    }
                    Button(action: {
                        // Add new language
                    }) {
                        Text("Add Language")
                    }
                }

                Section(header: Text("Overlay Characters")) {
                    TextField("Overlay Characters", text: $overlayCharacters)
                }

                Section(header: Text("Output")) {
                    Toggle("Instant Output", isOn: $instantOutput)
                    if !instantOutput {
                        Stepper("Output Speed: \(outputSpeed)", value: $outputSpeed, in: 1...10)
                    }
                }

                Section(header: Text("API Key")) {
                    TextField("API Key", text: $apiKey)
                }

                Section(header: Text("Custom API Host")) {
                    TextField("Custom API Host", text: $customApiHost)
                    Toggle("Enable Custom API Host", isOn: $customApiHostEnabled)
                }

                Section(header: Text("Style Prompt")) {
                    Picker("Style Prompt Selection", selection: $stylePromptSelection) {
                        Text("None").tag(0)
                        Text("Predefined").tag(1)
                        Text("Custom").tag(2)
                    }
                    if stylePromptSelection == 2 {
                        TextField("Custom Style Prompt", text: $stylePromptCustomText)
                    }
                }

                Section(header: Text("Resend Button")) {
                    Toggle("Enable Resend Button", isOn: $resendButton)
                }

                Section(header: Text("Instant Recording")) {
                    Toggle("Enable Instant Recording", isOn: $instantRecording)
                }

                Section(header: Text("Post-Processing")) {
                    Toggle("Enable Post-Processing", isOn: $postProcessingEnabled)
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
