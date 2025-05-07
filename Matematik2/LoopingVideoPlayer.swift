//
//  LoopingVideoPlayer.swift
//  Nobla Math
//
//  Created by Sebastian Strus on 2025-04-29.
//


import SwiftUI
import AVKit

struct LoopingVideoPlayer: View {
    @ObservedObject var viewModel: VideoPlayerViewModel

    var body: some View {
        #if os(iOS)
        iOSVideoPlayer(viewModel: viewModel)
        #elseif os(macOS)
        macOSVideoPlayer(viewModel: viewModel)
        #endif
    }
}

#if os(iOS)
struct iOSVideoPlayer: UIViewControllerRepresentable {
    @ObservedObject var viewModel: VideoPlayerViewModel

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = viewModel.player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        return controller
    }

    func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
        // No-op
    }
}
#elseif os(macOS)
import SwiftUI
import AVKit

struct macOSVideoPlayer: NSViewRepresentable {
    @ObservedObject var viewModel: VideoPlayerViewModel

    func makeNSView(context: Context) -> AVPlayerView {
        let playerView = AVPlayerView()
        playerView.player = viewModel.player
        playerView.showsFullScreenToggleButton = false
        playerView.controlsStyle = .none
        playerView.videoGravity = .resizeAspectFill
        return playerView
    }

    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        // No update needed
    }
}
#endif



import Foundation
import AVKit
import Combine

class VideoPlayerViewModel: ObservableObject {
    static let shared = VideoPlayerViewModel()
    
    let player: AVQueuePlayer
    private var looper: AVPlayerLooper?
    
    init() {
        let url = Bundle.main.url(forResource: "background_video", withExtension: "mov")

        let item = AVPlayerItem(url: url!)
        self.player = AVQueuePlayer()
        self.looper = AVPlayerLooper(player: player, templateItem: item)

        player.play()

        // Resume playback when app becomes active
        #if os(iOS)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resumePlayback),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        #elseif os(macOS)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resumePlayback),
            name: NSApplication.willBecomeActiveNotification,
            object: nil
        )
        #endif
    }

    @objc private func resumePlayback() {
        player.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
