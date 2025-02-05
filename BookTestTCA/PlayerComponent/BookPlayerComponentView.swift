//
//  BookPlayerComponentView.swift
//  BookTestTCA
//
//  Created by Mykola Hrybeniuk on 05.02.2025.
//

import SwiftUI
import ComposableArchitecture
import AVFoundation

struct BookPlayerComponentView: View {
    
    let store: StoreOf<BookPlayerComponentReducer>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                progressBar(viewStore: viewStore)
                changeSpeedButton(viewStore: viewStore)
                playerControlsButtonsStack(viewStore: viewStore)
                    .padding()
            }
            .padding()
            .onAppear(perform: {
                viewStore.send(.viewOnAppear)
            })
            
        }
    }
    
    @ViewBuilder private func progressBar(viewStore: ViewStore<BookPlayerComponentReducer.State, BookPlayerComponentReducer.Action>) -> some View {
        HStack(content: {
            Text(viewStore.currentTimeString)
            Slider(
                value: viewStore.binding(
                    get: \.currentTime,
                    send: BookPlayerComponentReducer.Action.seek
                ),
                in: 0...viewStore.totalTime
            )
            .padding()
            
            if viewStore.isLoadingTrackInfo {
                ProgressView()
                    .frame(width: 6, height: 6)
            } else {
                Text(viewStore.totalTimeString)
            }
        })
    }
    
    @ViewBuilder private func changeSpeedButton(viewStore: ViewStore<BookPlayerComponentReducer.State, BookPlayerComponentReducer.Action>) -> some View {
        Button(action: {
            viewStore.send(.changeSpeed)
        }, label: {
            ZStack(content: {
                Text("Speed x" + String(viewStore.speed))
                    .padding(.all, 8)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
            })
            .background(.gray.opacity(0.3))
            .cornerRadius(8)
        })
    }
    
    @ViewBuilder private func playerControlsButtonsStack(viewStore: ViewStore<BookPlayerComponentReducer.State, BookPlayerComponentReducer.Action>) -> some View {
        HStack {
            Button(action: { viewStore.send(.previousTrack) }) {
                playerImageControl(imageWithName: "backward.end.fill")
            }
            
            Button(action: { viewStore.send(.jumpBackward) }) {
                playerImageControl(imageWithName: "gobackward.5")
            }
            
            Button(action: {
                viewStore.send(.playPauseTapped)
            }) {
                playerImageControl(imageWithName: viewStore.isPlaying ? "pause.fill" : "play.fill")
            }
            
            Button(action: { viewStore.send(.jumpForward) }) {
                playerImageControl(imageWithName: "goforward.10")
            }
            
            Button(action: { viewStore.send(.nextTrack) }) {
                playerImageControl(imageWithName: "forward.end.fill")
            }
        }
    }
    
    @ViewBuilder private func playerImageControl(imageWithName: String) -> some View {
        Image(systemName: imageWithName)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.black)
            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}


#Preview {
    BookPlayerComponentView(store: .init(initialState: .init(), reducer: {}))
}
