# Clarity Dictation Keyboard (Whisper AI transcription)

Clarity Dictation is an easy-to-use SwiftUI keyboard app for transcribing and dictating. The app uses [OpenAI Whisper](https://openai.com/index/whisper/) in the background, which supports extremely accurate results for [many different languages](https://platform.openai.com/docs/guides/speech-to-text/supported-languages) with punctuation and custom AI rewording using GPT-4 Omni. 

## Features

- SwiftUI-based keyboard for transcription
- Uses OpenAI's Whisper for accurate transcription
- Supports multiple languages
- Customizable prompts
- Easy-to-use interface

## Installation

To install the app, follow these steps:

1. Clone the repository:
   ```sh
   git clone https://github.com/lukeaslanian/ClarityDictation.git
   ```
2. Open the project in Xcode:
   ```sh
   cd ClarityDictation
   open ClarityDictation.xcodeproj
   ```
3. Set up your OpenAI API key:
   - Open `ClarityDictation/Info.plist`
   - Add your OpenAI API key under the key `OpenAIAPIKey`
4. Build and run the app on your iOS device or simulator.

## Usage

1. Launch the app on your iOS device.
2. Follow the onboarding instructions to grant necessary permissions and enter your API key.
3. Use the keyboard to start, stop, pause, and resume recording.
4. View the transcription result in the app.

## License

Clarity Dictation is under the terms of the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0), following all clarifications stated in the [license file](https://raw.githubusercontent.com/lukeaslanian/ClarityDictation/master/LICENSE)
