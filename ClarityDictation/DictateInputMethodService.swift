import SwiftUI
import AVFoundation

class DictateInputMethodService: ObservableObject {
    @Published var isRecording = false
    @Published var isPaused = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var infoMessage: String?
    @Published var transcriptionResult: String?
    @Published var isPostProcessingEnabled = true // Pb58f
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var audioFileURL: URL?
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioFileURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            audioRecorder = try AVAudioRecorder(url: audioFileURL!, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            isRecording = true
            isPaused = false
            elapsedTime = 0
            startTimer()
        } catch {
            infoMessage = "Recording failed: \(error.localizedDescription)"
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
        isPaused = false
        stopTimer()
        transcribeAudio()
    }
    
    func pauseRecording() {
        audioRecorder?.pause()
        isPaused = true
        stopTimer()
    }
    
    func resumeRecording() {
        audioRecorder?.record()
        isPaused = false
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func transcribeAudio() {
        guard let audioFileURL = audioFileURL else {
            infoMessage = "No audio file to transcribe"
            return
        }
        
        let whisperAPIEndpoint = "https://api.openai.com/v1/whisper"
        var request = URLRequest(url: URL(string: whisperAPIEndpoint)!)
        request.httpMethod = "POST"
        request.addValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")
        
        let fileData = try? Data(contentsOf: audioFileURL)
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n")
        body.append("Content-Type: audio/m4a\r\n\r\n")
        body.append(fileData!)
        body.append("\r\n--\(boundary)--\r\n")
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                self.infoMessage = "Transcription failed: \(error?.localizedDescription ?? "Unknown error")"
                return
            }
            
            if let transcription = try? JSONDecoder().decode(TranscriptionResponse.self, from: data) {
                self.transcriptionResult = transcription.text
                if self.isPostProcessingEnabled {
                    self.postProcessTranscription()
                }
            } else {
                self.infoMessage = "Failed to decode transcription response"
            }
        }.resume()
    }
    
    private func postProcessTranscription() {
        guard let transcriptionResult = transcriptionResult else {
            infoMessage = "No transcription result to process"
            return
        }
        
        let gpt4APIEndpoint = "https://api.openai.com/v1/engines/gpt-4/completions"
        var request = URLRequest(url: URL(string: gpt4APIEndpoint)!)
        request.httpMethod = "POST"
        request.addValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = "Reword the following text: \(transcriptionResult)"
        let requestBody: [String: Any] = [
            "prompt": prompt,
            "max_tokens": 100,
            "temperature": 0.7
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                self.infoMessage = "Post-processing failed: \(error?.localizedDescription ?? "Unknown error")"
                return
            }
            
            if let postProcessingResponse = try? JSONDecoder().decode(PostProcessingResponse.self, from: data) {
                self.transcriptionResult = postProcessingResponse.choices.first?.text
            } else {
                self.infoMessage = "Failed to decode post-processing response"
            }
        }.resume()
    }
}

extension DictateInputMethodService: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            infoMessage = "Recording failed"
        }
    }
}

struct TranscriptionResponse: Decodable {
    let text: String
}

struct PostProcessingResponse: Decodable {
    struct Choice: Decodable {
        let text: String
    }
    let choices: [Choice]
}
