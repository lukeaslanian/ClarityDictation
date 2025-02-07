import SwiftUI

struct PromptsKeyboardView: View {
    @ObservedObject var viewModel: DictateInputMethodService
    @State private var selectedPrompt: PromptModel?
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.startRecording()
                }) {
                    Image(systemName: "mic.fill")
                        .padding()
                        .background(viewModel.isRecording ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .disabled(viewModel.isRecording)
                
                Button(action: {
                    viewModel.stopRecording()
                }) {
                    Image(systemName: "stop.fill")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .disabled(!viewModel.isRecording)
                
                Button(action: {
                    if viewModel.isPaused {
                        viewModel.resumeRecording()
                    } else {
                        viewModel.pauseRecording()
                    }
                }) {
                    Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .disabled(!viewModel.isRecording)
            }
            
            Text("Elapsed Time: \(viewModel.elapsedTime, specifier: "%.1f") seconds")
                .padding()
            
            if let infoMessage = viewModel.infoMessage {
                Text(infoMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            List(viewModel.prompts) { prompt in
                Button(action: {
                    selectedPrompt = prompt
                }) {
                    Text(prompt.name)
                }
            }
            
            if let selectedPrompt = selectedPrompt {
                Text("Selected Prompt: \(selectedPrompt.name)")
                    .padding()
            }
        }
    }
}

struct PromptsKeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        PromptsKeyboardView(viewModel: DictateInputMethodService())
    }
}
