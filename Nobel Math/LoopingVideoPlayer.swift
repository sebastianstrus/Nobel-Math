//
//  LoopingVideoPlayer.swift
//  Nobel Math
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
    private var timeObserverToken: Any?
    private var cancellables = Set<AnyCancellable>()

    init() {
        guard let url = Bundle.main.url(forResource: "background_video", withExtension: "mov") else {
            fatalError("Video not found in bundle.")
        }

        let item = AVPlayerItem(url: url)
        self.player = AVQueuePlayer()
        self.looper = AVPlayerLooper(player: player, templateItem: item)

        player.play()

        // Observe if player stops playing
        startObservingPlayback()

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

    private func startObservingPlayback() {
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 5, preferredTimescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }

            if self.player.timeControlStatus != .playing {
                print("Playback stalled, restarting...")
                self.player.play()
            }
        }
    }

    @objc private func resumePlayback() {
        if player.timeControlStatus != .playing {
            print("Resuming playback...")
            player.play()
        }
    }

    deinit {
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
        }
        NotificationCenter.default.removeObserver(self)
    }
}
