//
//  BookPlayMainView.swift
//  BookTestTCA
//
//  Created by Mykola Hrybeniuk on 05.02.2025.
//

import AVFoundation
import ComposableArchitecture
import SwiftUI
import CachedAsyncImage

struct BookPlayMainView: View {
    
    let store: StoreOf<BookPlayMainReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            switch viewStore.downloadMode {
            case .notDownloaded:
                loadingView()
                    .onAppear() {
                        viewStore.send(.screenLoaded)
                    }
                
            case .downloading:
                loadingView()
                
            case .downloaded:
                VStack {
                    
                    if store.isLyricsScreenMode {
                        ScrollWithFadedEdgesView(text: viewStore.lyricsText)
                    } else {
                        bookCoverView(url: viewStore.coverImageUrl)
                    }
                    
                    chapterTrackInfoView(chaptersCount: viewStore.chaptersCount, chapterName: viewStore.chapterName)
                    
                    BookPlayerComponentView(store: store.scope(state: \.playerState, action: \.playerAction))
                    
                    toggleLyricsButtonView(viewStore.binding(get: \.isLyricsScreenMode, send: BookPlayMainReducer.Action.changeScreenType))

                }
                .padding()
                
            case .downloadingFailed:
                loadingView()
                .alert("Book loading is failed", isPresented: .constant(viewStore.downloadMode == .downloadingFailed)) {
                    Button("Try Again", role: .cancel) {
                        viewStore.send(.tryLoadBookAgain)
                    }
                }
                
            }
        }
        
    }
    
    @ViewBuilder func loadingView() -> some View {
        ZStack {
            ProgressView()
                .frame(width: 16, height: 16)
        }
    }
    
    @ViewBuilder func bookCoverView(url: URL?) -> some View {
        CachedAsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Image("book_cover")
                .resizable()
                .scaledToFit()
        }
        .cornerRadius(16)
    }
    
    @ViewBuilder func chapterTrackInfoView(chaptersCount: String, chapterName: String) -> some View {
        Text(chaptersCount)
            .foregroundStyle(.gray)
            .font(.system(size: 16, weight: .semibold))
            .padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        Text(chapterName)
            .font(.system(size: 14, weight: .semibold))
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder func toggleLyricsButtonView(_ binding: Binding<Bool>) -> some View {
        ToggleButtonView(isRightSelected: binding,
                         leftIcon: "headphones",
                         rightIcon: "text.alignleft")
    }

}

#Preview {
    BookPlayMainView(store: .init(initialState: BookPlayMainReducer.State.init(metadataUrlString: metadataURLString,
                                                                               downloadMode: .downloaded, isLyricsScreenMode: .init(false), playerState: .init()), reducer: {}))
}
