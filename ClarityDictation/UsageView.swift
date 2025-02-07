import SwiftUI

struct UsageView: View {
    @StateObject private var viewModel = UsageViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.usageData.isEmpty {
                    Text("No usage data available")
                        .padding()
                } else {
                    List(viewModel.usageData) { usage in
                        VStack(alignment: .leading) {
                            Text(usage.modelName)
                                .font(.headline)
                            if usage.inputTokens > 0 {
                                Text("Input Tokens: \(usage.inputTokens)")
                            }
                            if usage.outputTokens > 0 {
                                Text("Output Tokens: \(usage.outputTokens)")
                            }
                            if usage.audioTime > 0 {
                                Text("Audio Time: \(usage.audioTime) seconds")
                            }
                            Text("Total Cost: \(usage.totalCost, specifier: "%.6f")")
                        }
                        .padding()
                    }
                }
                Spacer()
                HStack {
                    Button(action: {
                        viewModel.resetUsageData()
                    }) {
                        Text("Reset Usage")
                            .foregroundColor(.red)
                    }
                    .padding()
                    Spacer()
                    Button(action: {
                        if let url = URL(string: "https://platform.openai.com/settings/organization/billing/overview") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Buy Credits")
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }
            .navigationTitle("Usage")
            .onAppear {
                viewModel.loadUsageData()
            }
        }
    }
}

class UsageViewModel: ObservableObject {
    @Published var usageData: [UsageModel] = []

    func loadUsageData() {
        // Load usage data from the database
        let dbHelper = UsageDatabaseHelper()
        usageData = dbHelper.getAll()
    }

    func resetUsageData() {
        // Reset usage data in the database
        let dbHelper = UsageDatabaseHelper()
        dbHelper.reset()
        loadUsageData()
    }
}

struct UsageView_Previews: PreviewProvider {
    static var previews: some View {
        UsageView()
    }
}
