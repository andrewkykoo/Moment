//
//  VoiceRecordingView.swift
//  Moment
//
//  Created by Andrew Koo on 1/14/24.
//

import SwiftUI
import AVFoundation
import Speech

struct VoiceRecordingView: View {
    @ObservedObject var viewModel: MomentsViewModel
    @State private var recordedText: String = ""
    @State private var isRecording = false
    @State private var navigateToDetail = false
    @State private var isNavigatingAway = false
    
    @State private var audioEngine = AVAudioEngine()
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    @State private var request: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?

    var body: some View {
        VStack {
            if isRecording {
                Text("Recording...")
                    .foregroundStyle(.red)
                    .font(.headline)
            }
            
            Text(recordedText)
                .padding()
            
            Button(isRecording ? "Cancel" : "Start Recording") {
                isRecording.toggle()
                if isRecording {
                    startRecording()
                } else {
                    stopRecording()
                    recordedText = ""
                }
            }
            
            if !recordedText.isEmpty {
                Button("Use this text") {
                    viewModel.recordedText = recordedText
                    navigateToDetail = true
                    isNavigatingAway = true
                    finalizeRecording()
                }
            }
        }
        .navigationDestination(isPresented: $navigateToDetail) {
            SaveMomentView(viewModel: viewModel, momentType: .voice)
        }
        .onDisappear {
            if isRecording && !isNavigatingAway {
                stopRecording()
            }
        }
    }
    
    private func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session for recording: \(error.localizedDescription)")
            return
        }
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    startRecordingProcess()
                case .denied, .restricted, .notDetermined:
                    // Handle denied access
                    print("Speech recognition authorization denied")
                default:
                    print("Unknown authorization status")
                }
            }
        }
    }

    private func startRecordingProcess() {
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        guard let speechRecognizer = speechRecognizer else {
            print("Speech recognizer is not available for the specified locale.")
            return
        }
        
        if inputNode.numberOfInputs > 0 {
            inputNode.removeTap(onBus: 0)
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request?.append(buffer)
        }

        do {
            try audioEngine.start()
        } catch {
            print("Audio Engine Start Error: \(error.localizedDescription)")
        }

        let newRequest = SFSpeechAudioBufferRecognitionRequest()
        request = newRequest
        newRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: newRequest) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("speech recognition error: \(error.localizedDescription)")
                    return
                }
                if let result = result {
                    self.recordedText = result.bestTranscription.formattedString
                }
                if error != nil || result?.isFinal == true {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.request = nil
                    self.recognitionTask = nil
                    self.isRecording = false
                }
            }
        }
    }


    private func stopRecording() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        request?.endAudio()
        recognitionTask?.cancel()
        isRecording = false
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
    
    private func finalizeRecording() {
        if isRecording {
            stopRecording()
        }
    }
}

//#Preview {
//    VoiceRecordingView(viewModel: MomentsViewModel())
//}
