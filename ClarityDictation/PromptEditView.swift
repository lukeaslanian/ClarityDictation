import SwiftUI

struct PromptEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var promptName: String = ""
    @State private var promptText: String = ""
    @State private var requiresSelection: Bool = false
    @State private var isSaveButtonEnabled: Bool = false
    @ObservedObject var viewModel: PromptEditViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Prompt Details")) {
                    TextField("Prompt Name", text: $promptName)
                        .onChange(of: promptName) { _ in
                            validateForm()
                        }
                    TextField("Prompt Text", text: $promptText)
                        .onChange(of: promptText) { _ in
                            validateForm()
                        }
                    Toggle(isOn: $requiresSelection) {
                        Text("Requires Selection")
                    }
                }
                Section {
                    Button(action: savePrompt) {
                        Text("Save Prompt")
                    }
                    .disabled(!isSaveButtonEnabled)
                }
            }
            .navigationBarTitle("Edit Prompt", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            if let prompt = viewModel.prompt {
                promptName = prompt.name
                promptText = prompt.text
                requiresSelection = prompt.requiresSelection
                validateForm()
            }
        }
    }

    private func validateForm() {
        isSaveButtonEnabled = !promptName.isEmpty && !promptText.isEmpty
    }

    private func savePrompt() {
        if let prompt = viewModel.prompt {
            viewModel.updatePrompt(id: prompt.id, name: promptName, text: promptText, requiresSelection: requiresSelection)
        } else {
            viewModel.addPrompt(name: promptName, text: promptText, requiresSelection: requiresSelection)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

class PromptEditViewModel: ObservableObject {
    @Published var prompt: PromptModel?

    private let databaseHelper = PromptsDatabaseHelper()

    func addPrompt(name: String, text: String, requiresSelection: Bool) {
        let newPrompt = PromptModel(id: UUID(), name: name, text: text, requiresSelection: requiresSelection)
        databaseHelper.addPrompt(newPrompt)
    }

    func updatePrompt(id: UUID, name: String, text: String, requiresSelection: Bool) {
        if var prompt = prompt {
            prompt.name = name
            prompt.text = text
            prompt.requiresSelection = requiresSelection
            databaseHelper.updatePrompt(prompt)
        }
    }
}

struct PromptEditView_Previews: PreviewProvider {
    static var previews: some View {
        PromptEditView(viewModel: PromptEditViewModel())
    }
}
