import SwiftUI

struct StylePromptView: View {
    @AppStorage("stylePromptSelection") private var stylePromptSelection = 1
    @AppStorage("stylePromptCustomText") private var stylePromptCustomText = ""

    var body: some View {
        Form {
            Section(header: Text("Style Prompt")) {
                Picker("Style Prompt Selection", selection: $stylePromptSelection) {
                    Text("None").tag(0)
                    Text("Predefined").tag(1)
                    Text("Custom").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())

                if stylePromptSelection == 2 {
                    TextField("Custom Style Prompt", text: $stylePromptCustomText)
                }
            }

            Section {
                Button(action: {
                    if let url = URL(string: "https://platform.openai.com/docs/guides/speech-to-text/prompting") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "questionmark.circle")
                        Text("Learn more about prompting")
                    }
                }
            }
        }
        .navigationBarTitle("Style Prompt")
    }
}

struct StylePromptView_Previews: PreviewProvider {
    static var previews: some View {
        StylePromptView()
    }
}
