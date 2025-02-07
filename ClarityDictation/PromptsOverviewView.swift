import SwiftUI

struct PromptsOverviewView: View {
    @ObservedObject var viewModel: PromptsOverviewViewModel
    @State private var isPresentingEditPrompt = false
    @State private var selectedPrompt: PromptModel?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.prompts) { prompt in
                    HStack {
                        Text(prompt.name)
                        Spacer()
                        Button(action: {
                            selectedPrompt = prompt
                            isPresentingEditPrompt = true
                        }) {
                            Image(systemName: "pencil")
                        }
                    }
                }
                .onDelete(perform: deletePrompt)
                .onMove(perform: movePrompt)
            }
            .navigationBarTitle("Prompts Overview")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                selectedPrompt = nil
                isPresentingEditPrompt = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isPresentingEditPrompt) {
                if let selectedPrompt = selectedPrompt {
                    PromptEditView(viewModel: PromptEditViewModel(prompt: selectedPrompt))
                } else {
                    PromptEditView(viewModel: PromptEditViewModel())
                }
            }
        }
    }

    private func deletePrompt(at offsets: IndexSet) {
        for index in offsets {
            let prompt = viewModel.prompts[index]
            viewModel.deletePrompt(prompt)
        }
    }

    private func movePrompt(from source: IndexSet, to destination: Int) {
        viewModel.movePrompt(from: source, to: destination)
    }
}

class PromptsOverviewViewModel: ObservableObject {
    @Published var prompts: [PromptModel] = []

    private let databaseHelper = PromptsDatabaseHelper()

    init() {
        loadPrompts()
    }

    func loadPrompts() {
        prompts = databaseHelper.getAllPrompts()
    }

    func deletePrompt(_ prompt: PromptModel) {
        databaseHelper.deletePrompt(by: prompt.id)
        loadPrompts()
    }

    func movePrompt(from source: IndexSet, to destination: Int) {
        prompts.move(fromOffsets: source, toOffset: destination)
        // Update the positions in the database if needed
    }
}

struct PromptsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        PromptsOverviewView(viewModel: PromptsOverviewViewModel())
    }
}
