import Foundation

struct DictateUtils {
    static let promptPunctuationCapitalization = "The Great Wall of China, the Eiffel Tower, the Pyramids of Giza, and the Statue of Liberty are among the most iconic landmarks in the world, and they draw countless tourists every year who marvel at their grandeur and historical significance."
    static let promptRewordingBePrecise = "Be accurate with your output. Only output exactly what the user has asked for above. Do not add any text before or after the actual output. Output the text in the language of the instruction, unless a different language was explicitly requested."

    static func calcModelCost(modelName: String, audioTime: TimeInterval, inputTokens: Int, outputTokens: Int) -> Double {
        switch modelName {
        case "whisper-1":
            return audioTime * 0.0001
        case "gpt-4o-mini":
            return Double(inputTokens) * 0.00000015 + Double(outputTokens) * 0.0000006
        case "gpt-4o":
            return Double(inputTokens) * 0.0000025 + Double(outputTokens) * 0.00001
        case "gpt-4-turbo":
            return Double(inputTokens) * 0.00001 + Double(outputTokens) * 0.00003
        case "gpt-4":
            return Double(inputTokens) * 0.00003 + Double(outputTokens) * 0.00006
        case "gpt-3.5-turbo":
            return Double(inputTokens) * 0.0000005 + Double(outputTokens) * 0.0000015
        default:
            return 0
        }
    }

    static func translateModelName(modelName: String) -> String {
        switch modelName {
        case "whisper-1":
            return "Whisper"
        case "gpt-4o-mini":
            return "GPT-4o mini"
        case "gpt-4o":
            return "GPT-4o"
        case "gpt-4-turbo":
            return "GPT-4 Turbo"
        case "gpt-4":
            return "GPT-4"
        case "gpt-3.5-turbo":
            return "GPT-3.5 Turbo"
        default:
            return "Unknown"
        }
    }

    static func translateLanguageToEmoji(language: String) -> String {
        switch language {
        case "detect":
            return "✨"
        case "af":
            return "🇿🇦"
        case "ar":
            return "🇸🇦"
        case "hy":
            return "🇦🇲"
        case "az":
            return "🇦🇿"
        case "be":
            return "🇧🇾"
        case "bs":
            return "🇧🇦"
        case "bg":
            return "🇧🇬"
        case "ca":
            return "🇨🇦"
        case "zh":
            return "🇨🇳"
        case "hr":
            return "🇭🇷"
        case "cs":
            return "🇨🇿"
        case "da":
            return "🇩🇰"
        case "nl":
            return "🇳🇱"
        case "en":
            return "🇬🇧"
        case "et":
            return "🇪🇪"
        case "fi":
            return "🇫🇮"
        case "fr":
            return "🇫🇷"
        case "gl":
            return "🇬🇦"
        case "de":
            return "🇩🇪"
        case "el":
            return "🇬🇷"
        case "he":
            return "🇮🇱"
        case "hi":
            return "🇮🇳"
        case "hu":
            return "🇭🇺"
        case "is":
            return "🇮🇸"
        case "id":
            return "🇮🇩"
        case "it":
            return "🇮🇹"
        case "ja":
            return "🇯🇵"
        case "kn":
            return "🇰🇳"
        case "kk":
            return "🇰🇿"
        case "ko":
            return "🇰🇷"
        case "lv":
            return "🇱🇻"
        case "lt":
            return "🇱🇹"
        case "mk":
            return "🇲🇰"
        case "ms":
            return "🇲🇾"
        case "mr":
            return "🇲🇷"
        case "mi":
            return "🇲🇭"
        case "ne":
            return "🇳🇵"
        case "no":
            return "🇳🇴"
        case "fa":
            return "🇮🇷"
        case "pl":
            return "🇵🇱"
        case "pt":
            return "🇵🇹"
        case "ro":
            return "🇷🇴"
        case "ru":
            return "🇷🇺"
        case "sr":
            return "🇷🇸"
        case "sk":
            return "🇸🇰"
        case "sl":
            return "🇸🇮"
        case "es":
            return "🇪🇸"
        case "sw":
            return "🇸🇿"
        case "sv":
            return "🇸🇪"
        case "tl":
            return "🇵🇭"
        case "ta":
            return "🇹🇦"
        case "th":
            return "🇹🇭"
        case "tr":
            return "🇹🇷"
        case "uk":
            return "🇺🇦"
        case "ur":
            return "🇵🇰"
        case "vi":
            return "🇻🇳"
        case "cy":
            return "🏴"
        default:
            return ""
        }
    }
}
