import Foundation

struct PromptModel: Identifiable, Codable {
    var id: UUID
    var name: String
    var text: String
    var requiresSelection: Bool

    init(id: UUID = UUID(), name: String, text: String, requiresSelection: Bool) {
        self.id = id
        self.name = name
        self.text = text
        self.requiresSelection = requiresSelection
    }
}
