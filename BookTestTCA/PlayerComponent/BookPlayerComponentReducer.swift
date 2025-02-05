//
//  BookPlayerComponentReducer.swift
//  BookTestTCA
//
//  Created by Mykola Hrybeniuk on 05.02.2025.
//

import SwiftUI
import ComposableArchitecture
import XCTestDynamicOverlay

@Reducer
struct BookPlayerComponentReducer {
    
    @ObservableState
    struct State: Equatable {
        let id: UUID = UUID()
        var currentTime: Double = 0.0
        var speed: Int = 1
        var totalTime: Double = 0.0
        var isPlaying: Bool = false
        var currentTrack: URL?
        var isLoadingTrackInfo: Bool = false
        var totalTimeString: String { format(time: totalTime) }
        var currentTimeString: String { format(time: currentTime) }
        
        private func format(time: Double) -> String {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            if let str = formatter.string(from: time) {
                return str
            }
            return ""
        }
    }
    
    enum Action: Equatable {
        case viewOnAppear
        case playPauseTapped
        case playFromStart
        case seek(Double)
        case jumpBackward
        case jumpForward
        case previousTrack
        case nextTrack
        case totalTime(Double)
        case currentTime(Double)
        case loadTrackInfo
        case changeSpeed
        case tick
        case pause
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .viewOnAppear:
                return .none
                
            case .playPauseTapped:
                return .none
            
            case .playFromStart:
                return .none

            case .pause:
                return .none
                
            case .seek(let time):
                return .none
                
            case .jumpBackward:
                return .none
                
            case .jumpForward:
                return .none
                
            case .previousTrack, .nextTrack:
                return .none
                
            case .totalTime(let duration):
                state.totalTime = duration
                state.isLoadingTrackInfo = false
                return .none
                
            case .loadTrackInfo:
                return .none
                
            case .currentTime(let currentTime):
                return .none
                
            case .changeSpeed:
                return .none
                
            case .tick:
                return .none
            }
        }
        
    }
    
    @MainActor private func isUrlAlreadyPlaying(urlTrack: URL) -> Bool {
        return false
    }
    
}
