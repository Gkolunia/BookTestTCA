//
//  BookPlayMainReducer.swift
//  BookTestTCA
//
//  Created by Mykola Hrybeniuk on 05.02.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BookPlayMainReducer {
    
    @ObservableState
    struct State: Equatable {
        let metadataUrlString: String
        var downloadMode: Mode = .notDownloaded
        var coverImageUrl: URL?
        var keyPoints: [Metadata.Chapter] = []
        var isLyricsScreenMode: Bool = false
        
        var currentChapter: Metadata.Chapter?
        var chaptersCount: String = ""
        var lyricsText: String { currentChapter?.text ?? "" }
        var chapterName: String { currentChapter?.title ?? "" }
        var currentUrl: URL? {
            guard let url = currentChapter?.fileUrl else {
                return nil
            }
            return URL(string: url)
        }
        
        var playerState: BookPlayerComponentReducer.State
    }
    
    enum Action {
        case changeScreenType
        case screenLoaded
        case tryLoadBookAgain
        case downloadMetaData(Result<Metadata, Error>)
        case playerAction(BookPlayerComponentReducer.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.playerState, action: \.playerAction) {
            BookPlayerComponentReducer()
        }
        Reduce { state, action in
            
            switch action {
            case .changeScreenType:
                state.isLyricsScreenMode.toggle()
                return .none
                
            case .screenLoaded, .tryLoadBookAgain:
                state.downloadMode = .initialDownloading
                return .none
                
            case .downloadMetaData(.success(let metaData)):
                state.coverImageUrl = URL.init(string: metaData.imageUrl)
                state.downloadMode = .downloaded
                state.keyPoints = metaData.keyPoints
                state.currentChapter = metaData.keyPoints.first
                state.downloadMode = .downloaded
                state.playerState.currentTrack = state.currentUrl
                state.chaptersCount = "KEY POINT 1 OF \(metaData.keyPoints.count)"
                return .none
   
            case .downloadMetaData(.failure):
                state.downloadMode = .downloadingFailed
                return .none
            
            case .playerAction(let playerAction):
                switch playerAction {
                case .nextTrack:
                    return .send(.playerAction(.pause))
                    
                case .previousTrack:
                    return .send(.playerAction(.playFromStart))
                    
                default:
                    break
                }

                return .none
            }
        }
    }
    
    private func setState(for item: Metadata.Chapter, state: inout State) {
        let index = state.keyPoints.firstIndex(of: item) ?? 0
        state.chaptersCount = "KEY POINT \(index + 1) OF \(state.keyPoints.count)"
        state.currentChapter = item
        state.playerState.currentTrack = state.currentUrl
    }
    
}

enum Mode: Equatable {
    case initialDownloading
    case downloading
    case downloaded
    case notDownloaded
    case downloadingFailed
}
