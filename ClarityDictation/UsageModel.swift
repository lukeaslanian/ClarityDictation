import Foundation

struct UsageModel: Identifiable {
    let id = UUID()
    let modelName: String
    let audioTime: TimeInterval
    let inputTokens: Int
    let outputTokens: Int

    var totalCost: Double {
        return DictateUtils.calcModelCost(modelName: modelName, audioTime: audioTime, inputTokens: inputTokens, outputTokens: outputTokens)
    }
}
